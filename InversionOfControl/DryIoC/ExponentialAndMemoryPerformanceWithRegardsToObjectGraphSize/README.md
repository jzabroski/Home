# Exponential memory/performance with regards to the object graph size.

https://web.archive.org/web/20200702150542/https://bitbucket.org/dadhi/dryioc/issues/152/exponential-memory-performance-with

Issue #152 RESOLVED

Fyodor Soikin created an issue 2015-08-31

Imagine the following architecture:

Plugins of two types - say `IP` and `IQ`.
For each type there is an "aggregator" or "dispatcher" object, which gathers all plugins of its type and provides some sort of service over them. Let's call these `AggP` and `AggQ`.
All (or most) `Q` plugins use the service provided by `AggP`.
The root component uses service provided by `AggQ`.
Abbreviated code (full version is attached):

```c#
    public interface IP { }
    public interface IQ { }
    public class AggP { public AggP( IEnumerable<IP> ps ) { } }
    public class AggQ { public AggQ( IEnumerable<IQ> qs ) { } }
    public class Root { public Root( IEnumerable<AggQ> qs ) { } }

    class P1 : IP { }
    class P2 : IP { }
    ...
    class Pn : IP { }

    class Q1 : IQ { public Q1( AggP ps ) { } }
    class Q2 : IQ { public Q2( AggP ps ) { } }
    ...
    class Qn : IQ { public Qn( AggP ps ) { } }

    static void Main() {
        var c = new Container();
        c.Register<AggQ>( Reuse.InCurrentScope );
        c.Register<AggP>( Reuse.InCurrentScope );
        c.Register<Root>( Reuse.InCurrentScope );

        c.Register<IP, P1>( Reuse.InCurrentScope );
        ...
        c.Register<IP, Pn>( Reuse.InCurrentScope );

        c.Register<IQ, Q1>( Reuse.InCurrentScope );
        ...
        c.Register<IQ, Qn>( Reuse.InCurrentScope );

        using( var scope = c.OpenScope() ) {
            scope.Resolve<Root>();
        }
    }
```

The above code results in expression for Root of the following shape:

```c#
r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(16, () => 
    new Root(new [] {
        r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(14, 
            () => new AggQ( new [] {
                r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(67, 
                    () => new Q1(
                        r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(15, 
                            () => new AggP(new [] {
                                r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(17,
                                    () => new P1())), 
                                r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(18,
                                    () => new P2())), 
                                r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(19, 
                                    () => new P3()))
                                ...
                                r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(19, 
                                    () => new P50()))
                            }))),
                    () => new Q2(
                        r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(15, 
                            () => new AggP(new [] {
                                r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(17,
                                    () => new P1())), 
                                r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(18,
                                    () => new P2())), 
                                r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(19, 
                                    () => new P3()))
                                ...
                                r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(19, 
                                    () => new P50()))
                            }))),
                    ...
                    () => new Qn(
                        r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(15, 
                            () => new AggP(new [] {
                                r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(17,
                                    () => new P1())), 
                                r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(18,
                                    () => new P2())), 
                                r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(19, 
                                    () => new P3()))
                                ...
                                r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(19, 
                                    () => new P50()))
                            })))
            }))
    }))
```

Resulting in a total of at least 2550 constructor calls (50 * 50 + 50, not counting other dependencies of `Qn` classes), instead of just 100 (50 + 50), which one would expect.

This causes very significant performance degradation, as well as memory consumption, during the call to `Expression.Compile`. On our particular system (which has more complex object graph) memory consumption went up to 8Gb, after which the whole application crashed due to an out-of-memory exception.

.
.
This behavior can be worked around by declaring AggQ's and AggP's dependencies as Lazy:
```c#
    public class AggP { public AggP( Lazy<IEnumerable<IP>> ps ) { } }
    public class AggQ { public AggQ( Lazy<IEnumerable<IQ>> qs ) { } }
```

in which case the resulting expression will be:

```c#
r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(16, 
   () => new Root(new [] { 
      r.Scopes.GetCurrentNamedScope(null, True).GetOrAdd(14, 
         () => new AggQ( new Lazy( 
            () => r.Resolver.ResolveKeyed( IEnumerable[IQ], Convert(null), True, null, scope))))))})))
```

But this workaround is unacceptable, because it cannot be enforced. Also, using this workaround will trigger issue #151.

I believe an easy fix would be to generate expression for `IEnumerable<IQ>` as `r.Resolver.ResolveKeyed(typeof(IEnumerable<IQ>) ...)` instead of splicing a new-array expression. But this should be combined with enabling caching for `IEnumerable` expressions (issue #151).

## A.cs

```c#
using System;
using System.Collections.Generic;
using DryIoc;

namespace Solution
{
	static class Program
	{
		public static void Main() {

			var c = new Container();
			c.Register<AggQ>( Reuse.InCurrentScope );
			c.Register<AggP>( Reuse.InCurrentScope );
			c.Register<Root>( Reuse.InCurrentScope );
			Register( c );

			using ( var scope = c.OpenScope() ) {
				var x = scope.Resolve<Root>();
			}
			Console.ReadLine();
		}

		public interface IP { }
		public interface IQ { }
		public class AggP { public AggP( IEnumerable<IP> ps ) { } }
		public class AggQ { public AggQ( IEnumerable<IQ> qs ) { } }
		public class Root { public Root( IEnumerable<AggQ> qs ) { } }

		class P1 : IP { public P1() { } }
		class P2 : IP { public P2() { } }
		class P3 : IP { public P3() { } }
		class P4 : IP { public P4() { } }
		class P5 : IP { public P5() { } }
		class P6 : IP { public P6() { } }
		class P7 : IP { public P7() { } }
		class P8 : IP { public P8() { } }
		class P9 : IP { public P9() { } }
		class P10 : IP { public P10() { } }
		class P11 : IP { public P11() { } }
		class P12 : IP { public P12() { } }
		class P13 : IP { public P13() { } }
		class P14 : IP { public P14() { } }
		class P15 : IP { public P15() { } }
		class P16 : IP { public P16() { } }
		class P17 : IP { public P17() { } }
		class P18 : IP { public P18() { } }
		class P19 : IP { public P19() { } }
		class P20 : IP { public P20() { } }
		class P21 : IP { public P21() { } }
		class P22 : IP { public P22() { } }
		class P23 : IP { public P23() { } }
		class P24 : IP { public P24() { } }
		class P25 : IP { public P25() { } }
		class P26 : IP { public P26() { } }
		class P27 : IP { public P27() { } }
		class P28 : IP { public P28() { } }
		class P29 : IP { public P29() { } }
		class P30 : IP { public P30() { } }
		class P31 : IP { public P31() { } }
		class P32 : IP { public P32() { } }
		class P33 : IP { public P33() { } }
		class P34 : IP { public P34() { } }
		class P35 : IP { public P35() { } }
		class P36 : IP { public P36() { } }
		class P37 : IP { public P37() { } }
		class P38 : IP { public P38() { } }
		class P39 : IP { public P39() { } }
		class P40 : IP { public P40() { } }
		class P41 : IP { public P41() { } }
		class P42 : IP { public P42() { } }
		class P43 : IP { public P43() { } }
		class P44 : IP { public P44() { } }
		class P45 : IP { public P45() { } }
		class P46 : IP { public P46() { } }
		class P47 : IP { public P47() { } }
		class P48 : IP { public P48() { } }
		class P49 : IP { public P49() { } }
		class P50 : IP { public P50() { } }
		class Q1 : IQ { public Q1( AggP ps ) { } }
		class Q2 : IQ { public Q2( AggP ps ) { } }
		class Q3 : IQ { public Q3( AggP ps ) { } }
		class Q4 : IQ { public Q4( AggP ps ) { } }
		class Q5 : IQ { public Q5( AggP ps ) { } }
		class Q6 : IQ { public Q6( AggP ps ) { } }
		class Q7 : IQ { public Q7( AggP ps ) { } }
		class Q8 : IQ { public Q8( AggP ps ) { } }
		class Q9 : IQ { public Q9( AggP ps ) { } }
		class Q10 : IQ { public Q10( AggP ps ) { } }
		class Q11 : IQ { public Q11( AggP ps ) { } }
		class Q12 : IQ { public Q12( AggP ps ) { } }
		class Q13 : IQ { public Q13( AggP ps ) { } }
		class Q14 : IQ { public Q14( AggP ps ) { } }
		class Q15 : IQ { public Q15( AggP ps ) { } }
		class Q16 : IQ { public Q16( AggP ps ) { } }
		class Q17 : IQ { public Q17( AggP ps ) { } }
		class Q18 : IQ { public Q18( AggP ps ) { } }
		class Q19 : IQ { public Q19( AggP ps ) { } }
		class Q20 : IQ { public Q20( AggP ps ) { } }
		class Q21 : IQ { public Q21( AggP ps ) { } }
		class Q22 : IQ { public Q22( AggP ps ) { } }
		class Q23 : IQ { public Q23( AggP ps ) { } }
		class Q24 : IQ { public Q24( AggP ps ) { } }
		class Q25 : IQ { public Q25( AggP ps ) { } }
		class Q26 : IQ { public Q26( AggP ps ) { } }
		class Q27 : IQ { public Q27( AggP ps ) { } }
		class Q28 : IQ { public Q28( AggP ps ) { } }
		class Q29 : IQ { public Q29( AggP ps ) { } }
		class Q30 : IQ { public Q30( AggP ps ) { } }
		class Q31 : IQ { public Q31( AggP ps ) { } }
		class Q32 : IQ { public Q32( AggP ps ) { } }
		class Q33 : IQ { public Q33( AggP ps ) { } }
		class Q34 : IQ { public Q34( AggP ps ) { } }
		class Q35 : IQ { public Q35( AggP ps ) { } }
		class Q36 : IQ { public Q36( AggP ps ) { } }
		class Q37 : IQ { public Q37( AggP ps ) { } }
		class Q38 : IQ { public Q38( AggP ps ) { } }
		class Q39 : IQ { public Q39( AggP ps ) { } }
		class Q40 : IQ { public Q40( AggP ps ) { } }
		class Q41 : IQ { public Q41( AggP ps ) { } }
		class Q42 : IQ { public Q42( AggP ps ) { } }
		class Q43 : IQ { public Q43( AggP ps ) { } }
		class Q44 : IQ { public Q44( AggP ps ) { } }
		class Q45 : IQ { public Q45( AggP ps ) { } }
		class Q46 : IQ { public Q46( AggP ps ) { } }
		class Q47 : IQ { public Q47( AggP ps ) { } }
		class Q48 : IQ { public Q48( AggP ps ) { } }
		class Q49 : IQ { public Q49( AggP ps ) { } }
		class Q50 : IQ { public Q50( AggP ps ) { } }

		public static void Register( Container c ) {
			c.Register<IP, P1>( Reuse.InCurrentScope );
			c.Register<IP, P2>( Reuse.InCurrentScope );
			c.Register<IP, P3>( Reuse.InCurrentScope );
			c.Register<IP, P4>( Reuse.InCurrentScope );
			c.Register<IP, P5>( Reuse.InCurrentScope );
			c.Register<IP, P6>( Reuse.InCurrentScope );
			c.Register<IP, P7>( Reuse.InCurrentScope );
			c.Register<IP, P8>( Reuse.InCurrentScope );
			c.Register<IP, P9>( Reuse.InCurrentScope );
			c.Register<IP, P10>( Reuse.InCurrentScope );
			c.Register<IP, P11>( Reuse.InCurrentScope );
			c.Register<IP, P12>( Reuse.InCurrentScope );
			c.Register<IP, P13>( Reuse.InCurrentScope );
			c.Register<IP, P14>( Reuse.InCurrentScope );
			c.Register<IP, P15>( Reuse.InCurrentScope );
			c.Register<IP, P16>( Reuse.InCurrentScope );
			c.Register<IP, P17>( Reuse.InCurrentScope );
			c.Register<IP, P18>( Reuse.InCurrentScope );
			c.Register<IP, P19>( Reuse.InCurrentScope );
			c.Register<IP, P20>( Reuse.InCurrentScope );
			c.Register<IP, P21>( Reuse.InCurrentScope );
			c.Register<IP, P22>( Reuse.InCurrentScope );
			c.Register<IP, P23>( Reuse.InCurrentScope );
			c.Register<IP, P24>( Reuse.InCurrentScope );
			c.Register<IP, P25>( Reuse.InCurrentScope );
			c.Register<IP, P26>( Reuse.InCurrentScope );
			c.Register<IP, P27>( Reuse.InCurrentScope );
			c.Register<IP, P28>( Reuse.InCurrentScope );
			c.Register<IP, P29>( Reuse.InCurrentScope );
			c.Register<IP, P30>( Reuse.InCurrentScope );
			c.Register<IP, P31>( Reuse.InCurrentScope );
			c.Register<IP, P32>( Reuse.InCurrentScope );
			c.Register<IP, P33>( Reuse.InCurrentScope );
			c.Register<IP, P34>( Reuse.InCurrentScope );
			c.Register<IP, P35>( Reuse.InCurrentScope );
			c.Register<IP, P36>( Reuse.InCurrentScope );
			c.Register<IP, P37>( Reuse.InCurrentScope );
			c.Register<IP, P38>( Reuse.InCurrentScope );
			c.Register<IP, P39>( Reuse.InCurrentScope );
			c.Register<IP, P40>( Reuse.InCurrentScope );
			c.Register<IP, P41>( Reuse.InCurrentScope );
			c.Register<IP, P42>( Reuse.InCurrentScope );
			c.Register<IP, P43>( Reuse.InCurrentScope );
			c.Register<IP, P44>( Reuse.InCurrentScope );
			c.Register<IP, P45>( Reuse.InCurrentScope );
			c.Register<IP, P46>( Reuse.InCurrentScope );
			c.Register<IP, P47>( Reuse.InCurrentScope );
			c.Register<IP, P48>( Reuse.InCurrentScope );
			c.Register<IP, P49>( Reuse.InCurrentScope );
			c.Register<IP, P50>( Reuse.InCurrentScope );
			c.Register<IQ, Q1>( Reuse.InCurrentScope );
			c.Register<IQ, Q2>( Reuse.InCurrentScope );
			c.Register<IQ, Q3>( Reuse.InCurrentScope );
			c.Register<IQ, Q4>( Reuse.InCurrentScope );
			c.Register<IQ, Q5>( Reuse.InCurrentScope );
			c.Register<IQ, Q6>( Reuse.InCurrentScope );
			c.Register<IQ, Q7>( Reuse.InCurrentScope );
			c.Register<IQ, Q8>( Reuse.InCurrentScope );
			c.Register<IQ, Q9>( Reuse.InCurrentScope );
			c.Register<IQ, Q10>( Reuse.InCurrentScope );
			c.Register<IQ, Q11>( Reuse.InCurrentScope );
			c.Register<IQ, Q12>( Reuse.InCurrentScope );
			c.Register<IQ, Q13>( Reuse.InCurrentScope );
			c.Register<IQ, Q14>( Reuse.InCurrentScope );
			c.Register<IQ, Q15>( Reuse.InCurrentScope );
			c.Register<IQ, Q16>( Reuse.InCurrentScope );
			c.Register<IQ, Q17>( Reuse.InCurrentScope );
			c.Register<IQ, Q18>( Reuse.InCurrentScope );
			c.Register<IQ, Q19>( Reuse.InCurrentScope );
			c.Register<IQ, Q20>( Reuse.InCurrentScope );
			c.Register<IQ, Q21>( Reuse.InCurrentScope );
			c.Register<IQ, Q22>( Reuse.InCurrentScope );
			c.Register<IQ, Q23>( Reuse.InCurrentScope );
			c.Register<IQ, Q24>( Reuse.InCurrentScope );
			c.Register<IQ, Q25>( Reuse.InCurrentScope );
			c.Register<IQ, Q26>( Reuse.InCurrentScope );
			c.Register<IQ, Q27>( Reuse.InCurrentScope );
			c.Register<IQ, Q28>( Reuse.InCurrentScope );
			c.Register<IQ, Q29>( Reuse.InCurrentScope );
			c.Register<IQ, Q30>( Reuse.InCurrentScope );
			c.Register<IQ, Q31>( Reuse.InCurrentScope );
			c.Register<IQ, Q32>( Reuse.InCurrentScope );
			c.Register<IQ, Q33>( Reuse.InCurrentScope );
			c.Register<IQ, Q34>( Reuse.InCurrentScope );
			c.Register<IQ, Q35>( Reuse.InCurrentScope );
			c.Register<IQ, Q36>( Reuse.InCurrentScope );
			c.Register<IQ, Q37>( Reuse.InCurrentScope );
			c.Register<IQ, Q38>( Reuse.InCurrentScope );
			c.Register<IQ, Q39>( Reuse.InCurrentScope );
			c.Register<IQ, Q40>( Reuse.InCurrentScope );
			c.Register<IQ, Q41>( Reuse.InCurrentScope );
			c.Register<IQ, Q42>( Reuse.InCurrentScope );
			c.Register<IQ, Q43>( Reuse.InCurrentScope );
			c.Register<IQ, Q44>( Reuse.InCurrentScope );
			c.Register<IQ, Q45>( Reuse.InCurrentScope );
			c.Register<IQ, Q46>( Reuse.InCurrentScope );
			c.Register<IQ, Q47>( Reuse.InCurrentScope );
			c.Register<IQ, Q48>( Reuse.InCurrentScope );
			c.Register<IQ, Q49>( Reuse.InCurrentScope );
			c.Register<IQ, Q50>( Reuse.InCurrentScope );
		}
	}
}
```

Comments (27)
Fyodor Soikin REPORTER
On second thought, perhaps the "easy fix" I proposed would not fix the core problem, which is that the container splices expressions for dependencies into parent expressions, thus causing needless repetition. This may (and does) manifest even without `IEnumerable`, one just needs a rich enough dependency graph in order to reproduce this.

2015-08-31
Maksim Volkau REPO OWNER
Hi Fyodor,

I appreciate the detailed problem description.

There is multiple possibilities to work with big object graph:

1) DryIoc allows to replace inline dependency creation expression with call to `Resolve` (`Lazy` is implemented on top of that):

```c#
container.Register<Dep>(setup: Setup.With(asResolutionRoot: true));
container.Register<DepClient>();

container.Resolve<DepClient>(); // will be created as: new DepClient(r.Resolve<Dep>());
```

With _MefAttributedModel_ you can export `Dep` as following:

```c#
[Export, AsResolutionRoot]
public class Dep {}
```

2) Regarding IEnumerable you may specify to inject as LazyEnumerable, which basically calls ResolveMany underneath. Here is more info

You can switch to this behavior per container, that way achieving automatic split of object graph on each IEnumerable:

container.With(rules => rules.WithResolveIEnumerableAsLazyEnumerable());
Interesting that this topic was recently mentioned in SimpleInjector issue.

2015-08-31
Fyodor Soikin REPORTER
Unfortunately, option 1 is unenforceable - that is, I cannot determine when "as resolution root" would be required somewhere and crash if it's not there (or add it automatically). The only way to figure this out is to notice a performance problem and then spend ungodly amount of time debugging. Or, alternatively, I could just stick "as resolution root" onto every single registration (would that have any adverse effects)?
And finally, this option actually has two responsibilities: it controls the "break point" of the object graph, as well as scoping. So if I do this, my scoping rules may get screwed up.

As for option 2 - it only works for IEnumerable, and even then, it will be subject to issue #151. Which, hopefully, will be fixed soon, at which point I'll try that option.

2015-09-01
Maksim Volkau REPO OWNER
I could just stick "as resolution root" onto every single registration (would that have any adverse effects)?
Should not be much performance decrease. And it does not imply new resolution scope until you replace setup asResolutionRoot with openResolutionScope. There is still one known issue that I plan to address https://bitbucket.org/dadhi/dryioc/issues/122/decorator-is-not-handled-across-resolution

Also thinking about possible improvements in determining where to split graph. Currently dependency itself responsible for that. But we can add:

Allow consuming side to specify inject as Resolve.
Have automated per container rule to split on specific level of nesting.
What to you think?

Btw, I will update on IEnumerable later in #151. Still checking something.

2015-09-01
Fyodor Soikin REPORTER
I think that putting responsibility for this on either producer or consumer is a bad idea, because it implies that the consumer has knowledge about the producer and vice versa, which is kinda antithesis to IoC in the first place.

Putting responsibility on the registration code is the right idea, but it doesn't hold up in case of attributed model.

Automatic option seems cool, but I don't see how it could be implemented in a flexible way.

2015-09-01
Fyodor Soikin REPORTER
Found another problem: if I break the graph by using `Lazy` or `LazyEnumerable`, I lose diagnostic information when something goes wrong - i.e. the container can't tell me the full chain of dependencies anymore.

2015-09-01
Maksim Volkau REPO OWNER
Yes, that is drawback. Any ideas how to fix that? In theory?

2015-09-01
Fyodor Soikin REPORTER
Yes. In theory, the expression trees you're building should accept not an `IResolverContext`, but an `IRequestContext`, which would allow to access not just the resolver, but the current request as well.

This will open multiple possibilities right away:

You don't have to construct the whole graph in one expression, you can enumerate only immediate dependencies, and resolve them by threading the request down the chain.
Diagnostic information flows freely, regardless of intermediate "breaking out" of the generated expressions.
Takes care of issue #153 without the need to disable cache.
It makes perfect sense if you think about it: not having current request everywhere makes some instantiations "special". That is, if you're the root instantiation, you have access to request, otherwise you don't. Which then leads to this awkward situation where, if you need access to request, you need to "force" the container to treat you as "root".

2015-09-01
Maksim Volkau REPO OWNER
As I understood you mean run-time dependency location and resolution instead of generating full expression with all nested dependencies? If so that is "exactly" how Autofac, Ninject, and other first wave containers do, and why that's why they suffer in performance aspect.

Propagating Request in factory delegate seems very powerful but it has implications of performance - we need to maintain and stackup request as it goes. It also not lightweight and we need many of them (pooling may help here a bit though). And the main point, request should hold on runtime/creation info which is not available after delegate is created.

My direction with DryIoc is produce "erased", stateless, generated delegates that could be decoupled from container infrastructure and used separately. Look in DryIocZero for an example and imagine how to make it full context aware.

In ideal world I want to get rid off `RegisterDelegate` and probably `RegisterInstance`.

2015-09-01
Fyodor Soikin REPORTER
Sure, I understand your "philosophy", of course. But look what it's yielded so far: multiple inconsistencies, as well as possible performance problems that are hard to track or prevent.
Perhaps it's time to revisit the philosophy?

Why do you want to produce "stateless" delegates in the first place? Is it performance? But have you measured?
Those first-wave containers also don't use expression generation, so maybe that's their source of performance problems, and not request propagation?

And even then, if you want your delegates to be independent of the container, it's already a bit too late: you're passing in IResolverContext and IScopes anyway.

But ok, let's assume your philosophy as starting point and see what can be done. How about this:

First, make the Resolve method accept "parent request" - that way, it doesn't lose the stack, so it can do diagnostics as well as context-based instantiation.
But you don't really have to "thread" the request down the stack in order to do that: when constructing the expression tree, you can "bake in" the current request as a constant:

```c#
    new C( new Lazy<D>( () => r.Resolve( typeof(D), Const(parentReq), ... ) ) )
```

This way, you preserve the request at graph breaking points, but absent those, the request is completely erased.

Second, think about this: why do you need to disable caching?
My observation: you need to disable caching, because in some cases you want the expression to be slightly different than in others. As in the context-base case: you want the expression to depend on something derived from request.
When I put it this way, the solution presents itself immediately: you should always cache expressions, but use the request itself as your cache key instead of service type. Aka "memoization".
But then, this naïve implementation will lead to exponential explosion of the cache, which is also needless, since most expressions will be identical between requests. With that in mind, you should calculate the key as a function of F(Request), and in most simple cases you'll have F(r) = r.ServiceType, but you'll also allow overriding this function when needed, which will be the vehicle for context-based instantiation. Which will look something like this:

```c#
   c.RegisterContextBased( typeof( ILogger ), 
      args: req => req.Parent.ImplementationType,  // This will be rolled into the cache key, so F(r) = new { r.ServiceType, Args = args(r) }
      construct: args => new Logger( args.Name ) )
```

This way, you get access to request without reconstructing the expression every time.

So the bottom line would be:

Allow passing parent request to `IResolver.Resolve`.
Always cache expressions/delegates, remove the "no-caching" option.
For cache key, instead of just service type, use a more general notion of "create cache key given a request".
2015-09-02
John Zabroski
Well, @fsoikin The "bottom line" as it were should also include the answer to this question:

Why do you want to produce "stateless" delegates in the first place? Is it performance? But have you measured?
If it is performance, we should think of a benchmark for which to test with. You've already highlighted several useful scenarios to benchmark:

```c#
IEnumerable<T>
any object not an IEnumerable<T>
Lazy<T>
any object not a Lazy<T>
```

It would seem pretty straight-forward to then code-generate test classes, e.g. via `Mono.Cecil` or Kevin Montrose's `Sigil`. You simply have ability to configure, the work and span of a weighted undirected graph. We can then store the configuration for this weighted undirected graph as an adjacency matrix, to make building such test classes more declarative. Just thinking out loud. Open to discussing.

2015-09-08
Maksim Volkau REPO OWNER
Hi @fsoikin

Current state
I wanted stateless/static delegates at first because of performance and ability to create DynamicMethod from delegate (that was measured as well). Plus no closures - no surprises, all state is explicitly controlled. That how it was in v1.4.

Later I wanted to generate IoC framework agnostic delegates. Which makes container very lightweight (and generally working on any platform), self-contained and transparent. The result at the moment is DryIocZero package.

So how delegates looks like in pseudo-code:

```c#
A: (resolver, scope) => new A(new Lazy<B>(() => resolver.Resolve<B>()));
B: (resolver, scope) => new B(new C());
```

Those are resolution roots. The delegates are static and all input provided via arguments. That means that I can generate them at compile-time, and with a very little of infrastructure provide a container (that's basically what DryIocZero.Container is).

Let's see how context-based things are fit here at the moment. For instance if dependency S requires owner Type as parameter:

```c#
C: (resolver, scope) => new C(new S(typeof(C)));
D: (resolver, scope) => new D(new Lazy<S>(() => resolver.Resolve<S>())));
S: (resolver, scope) => new S(???); // resolved from Lazy above. Owner is root - unknown?
```
So everything is fine until we starting to use context-based things together with `Resolve` based dependencies (like `Lazy`).

Ideas to fix
IDEA 1: ADD CONTEXT TO RESOLVE
Provide the request context into resolve (starting with ownerType):

```c#
D: (resolver, scope, ownerType) => new D(new Lazy<S>(() => resolver.Resolve<S>(ownerType: typeof(D))));
S: (resolver, scope, ownerType) => new S(ownerType);
```

The question how to extend that to generic context?

The one way is to use provided delegate:

```c#
D: (resolver, scope, context) => new D(new Lazy<S>(() => resolver.Resolve<S>(context.WithOwner<D>())));
S: (resolver, scope, context) => new S(userHandler(context)); // ??? How to pass a userHandler
```

If user handler was defined as `Expression<Func<Context, T>>` then it is more easy task:

```c#
S: (resolver, scope, context) => new S(new Func<Context, Type>(ctx => ctx.OwnerType).Invoke(context));
```

Note: But expression may use some Types/libs that we should be aware when generating delegate. How to handle that?

IDEA 2: USE SOMETHING ELSE INSTEAD OF RESOLVE FOR LAZY DEPENDENCY
Open for ideas ...

**What about Setup.Condition**
```c#
c.Register<I, X>(setup: Setup.With(condition: request => request.Parent.ImplementationType == typeof(A)))
c.Register<I, Y>(setup: Setup.With(condition: request => request.Parent.ImplementationType != typeof(A)))
```
Generates:
```
A: (resolver, scope) => new A(new X());
B: (resolver, scope) => new B(new Y());
```
What if `I` is `Lazy`:

```c#
A: (resolver, scope) => new A(new Lazy<I>(() => resolver.Resolve<I>())) // where is context?
B: (resolver, scope) => new B(new Lazy<I>(() => resolver.Resolve<I>())) // where is context?
I:  (resolver, scope) => ??? // requires context
```
Fix with context:

```c#
A: (resolver, scope, context) => new A(new Lazy<I>(() => resolver.Resolve<I>(context.WithOwner<A>)))

// ??? Here I should generate two delegates for X and Y. Or do something fancy with condition inside delegate???
X: (resolver, scope, context) => ???
Y: (resolver, scope, context) => ???
```

**Conclusion**
I hope it sheds more light on what the deal. Any help appreciated.

2015-09-09
Fyodor Soikin REPORTER
I gave some ideas above. Something wrong with them?

2015-09-10
Maksim Volkau REPO OWNER
Can you show in example how do your idea work in generated delegates? I need an example similar to provided by me above.

2015-09-10
Fyodor Soikin REPORTER
I explained that exactly, and even gave a snippet:

```c#
new C( new Lazy<D>( () => r.Resolve( typeof(D), Const(parentReq), ... ) ) )
```

2015-09-10
Maksim Volkau REPO OWNER
Ok then how delegate for `D` should look like?

2015-09-10
Fyodor Soikin REPORTER
The delegate for `D` would look like this:

```c#
new D( Const(arg1), Const(arg2) )
```

Where `arg1` and `arg2` are calculated at time of expression generation using consumer-provided function(s) `request -> arg`.

2015-09-10
John Zabroski
I did a bit more researching on how to write a unit test to guarantee, over a robust test suite, how we can make sure we don't exhaust memory on the underlying hardware. It turns out it is very difficult to write a unit test that asks .NET how much memory a class reference is using. The best solution appears to be: http://earlz.net/view/2012/11/14/0317/get-real-memory-usage-for-a-type-in

I am hoping I can find some time this weekend to actually create the test harness for varying test executions.

2015-09-10
John Zabroski
There is basically one more test case we need to cover to guarantee we have controlled memory performance. Opening and closing a scope in a loop.

This basically guarantees the "Container" does not keep scopes lying around after it is done with it. In other words, testing automatically for indirect "static memory overhead". In code, this would be Fyodor's original example, but with:

```c#
        using( var scope = c.OpenScope() ) {
            scope.Resolve<Root>();
        }
```
in a loop:

```c#
for (int i = 0; i < 1000; i++)
{
        using( var scope = c.OpenScope() ) {
            scope.Resolve<Root>();
        }
}
```

This may seem a bit silly at first, but it basically covers what appears to be Maksim's biggest fear of using Memoization - that the Memoizer itself may cause more problems than it solves by not cleaning up after itself once `scope.Dispose()` is called on leaving the using block, as the cached key should be invalidated.

2015-09-11
Maksim Volkau REPO OWNER
Hi @fsoikin, @jzabroski

I will go for @fsoikin suggested route. Only without any embedded Const - everything will be provided via Resolve argument. The changes will affect resolution delegates cache but not the expression cache (at least for the moment). Also I need to change delegate generation in DryIocZero. After that I will tackle the related issues.

Thanks for ideas!

2015-09-13
John Zabroski
Hi Maksim. My friend Sandro had a suggestion albeit he didn't dig too deeply. Basically, part of your problem is your are imposing a total ordering in GetOrAdd, despite the fact it doesn't really matter. The basic idea is to replace GetOrAdd with lazy static class constructors. I was going to try this over the weekend but frankly tried enjoying last good weather day of the year here in Boston before cold winters :)

Similar tricks are seen in term rewrite systems like Maude where they refer to the trick as viewing the pools of 'terms' as a "soup" and so the order isn't decided until we need to decide it. The only gotcha with this is mutual recursion. Indirect left recursion as in a packrat parser is doable but tricky. Then the memory overhead will guarantee bounds based on the scope of the "look ahead" expression. It can still cost additional memory but not exponentially so.

Below is his chat transcript ---' Not sure I can provide much insight without knowing more about DryIoC. Just off the cuff, the repeated expressions for creating all the Pn are a red flag. It seems like something that ought to be memoized, ie. all those "new Pn()" expressions can be changed to a static member access expressions:

```c#
static class Constructor<T> where T : new() { public static readonly Func<T> Invoke = () => new T(); }
```

This moves the cost of compilation to the first static access, which happens only once outside the compilation causing the problems in that ticket. You can have that constructor delegate take a Scope parameter of some sort with which it can check to see if an instance already exists in the current scope:

```c#
static class Constructor<T> where T : new() { public static readonly Func<IScope, T> Empty = scope => scope.Exists<T>() ?? new T(); }
```

You can repeat this memoization pattern with all constructors of any signature too, since constructor signatures must be unique. This is what I do with the Sasa.Func.Constructor function [1]. So every "new X" expression in that ticket could become a Constructor<Func<IScope, TArg0, ..., TArgN, T>>.Invoke(...) invocation, or you move the scope check out of constructor delegate and into the outer expression so you only invoke the constructor delegate if the instance doesn't already exist.

This simplifies the complexity of the expression itself to a set of static field accesses, so it solves the immediate problem of exponential expression blowup, but it would be a little slower on execution if you compile it naively because you're invoking delegates instead of the constructor directly. If you take more control over compiling the expression, you can inline each of these calls because you know exactly what the delegate is doing given only its type signature.

Sandro

[1] https://sourceforge.net/p/sasa/code/ci/default/tree/Sasa/Func.cs#l1463

2015-09-14
Maksim Volkau REPO OWNER
Very interesting, Thanks. I do saw Sasa library previously and learned trick or two from it.

But generating classes and methods in DryIoc requires use of `Reflection.Emit` which I avoided so far, sticking with Expressions Trees.

Emit is very powerful but more tricky as well, so I will proceed using Expressions Trees (which served me well) until the real obstacle arrives.

As I said I am planning to address current Resolve weakness by passing request context into it. And then come up with per Container rule to automatically split long expressions via Resolve.

2015-09-14
Maksim Volkau REPO OWNER
changed status to open
2015-09-17
Maksim Volkau REPO OWNER
changed status to resolved
fixed: #152: Exponential memory/performance with regards to the object graph size. changed: Optimized space consumed by all Rules boolean flags into single Bit Flags field.

→ <<cset 51a2bf27f62d>>

2015-09-30
Maksim Volkau REPO OWNER
changed status to open
Was too fast to close. Need to check on original issue sample and may be adjust split level accordingly. Adding corresponding test now.

2015-09-30
Maksim Volkau REPO OWNER
Closing as of #152 is completed.

Also with the original example the problem is in a large number of aggregated services in collection. So the better way would be to use LazyEnumerable as a service collection.

2015-10-06
Maksim Volkau REPO OWNER
changed status to resolved
2015-10-06
