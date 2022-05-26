Wrapping dependency in Lazy and IEnumerable causes repeated expression recompilation
Issue #151 RESOLVED
Fyodor Soikin created an issue 2015-08-31

```c#
        interface I { }
        class C : I { }
        class D { public Lazy<IEnumerable<I>> I { get; set; } }

        public static void Main() {

            var c = new Container( Rules.Default.With( propertiesAndFields: p => p.ImplementationType.GetProperties().Select( PropertyOrFieldServiceInfo.Of ) ) );
            c.Register<I,C>( reuse: Reuse.InCurrentScope );
            c.Register<D>( reuse: Reuse.InCurrentScope );

            for( var k = 0; k < 3; k++ )
                using ( var i = c.OpenScope() ) Console.WriteLine( i.Resolve<D>().I.Value.Count() );
            Console.ReadLine();
        }
```

Running the above code results in calling `Factory.GetDelegateOrDefault` three times (verify by adding debug print here), which means recompiling the expression tree for new I[] { new C() } three times, causing performance degradation, as well as (possibly) memory leak.

I believe this happens because the default factory for `IEnumerable<T>` is setup to not cache the expression, for which I can see no reason.

Comments (8)

Fyodor Soikin REPORTER

edited description

2015-08-31

Fyodor Soikin REPORTER

edited description

2015-08-31

Maksim Volkau REPO OWNER
changed status to open

I will look. Cirtainly it was the reason for non caching, lets check is it still actual.

2015-08-31
Fyodor Soikin REPORTER

I just looked a bit more, and it seems that the reason for not caching is to support subsequent registrations. For example:

```c#
class C : I {}
class D : I {}

c.Register<I,C>();
var is1 = c.ResolveMany<I>();

c.Register<I,D>();
var is2 = c.ResolveMany<I>();
```

With caching, `is2` will contain only `C`, but not `D`, because `D` was registered when the expression for `IEnumerable<I>` was already generated and cached.

Now, personally, I think it's not a good idea to add new registrations after starting resolutions, this may lead to all kinds of bugs. And I believe that DI container should actually prohibit doing that (i.e. "seal after first access" semantics).

2015-08-31
Fyodor Soikin REPORTER

The more I think of it, the less sense it makes.
Sure, the exact code above would allow subsequent registrations. But this code wouldn't:

```c#
class C : I {}
class D : I {}
class E { 
   public IEnumerable<I> Is { get; set; }
}

c.Register<E>();
c.Register<I, C>();
var e1 = c.Resolve<E>();

c.Register<I, D>();
var e2 = c.Resolve<E>();

// Both e1.Is and e2.Is contain C, but not D
```

Because even though the `IEnumerable` expression isn't cached in isolation, it still ends up cached as part of expression for `E`.
So now it turns out that `E` will have different dependencies provided depending on where it was first created.

2015-09-01
Maksim Volkau REPO OWNER
Yes the non-caching does not provide any value at the moment, and better be removed for more deterministic behavior. Simply it is a bug. So fixing..

As for `LazyEnumerable` it is different thing and works on top of `ResolveMany`. The problem in using it in Atrributed Model that its introduces container dependent code:

```c#
public class X {
    public X([Import(typeof(LazyEnumerable<Y>))] IEnumerable<Y> ys) ...
```

May be it would be better to add something more container agnostic like `[AsLazyMany]` or similar.

2015-09-01
Maksim Volkau REPO OWNER
Now, personally, I think it's not a good idea to add new registrations after starting resolutions, this may lead to all kinds of bugs
Addressed in #154: Add ability to prohibit any further registrations in container - to produce resolve-only container

Working with original issue "repeated expression recompilation"

2015-09-02
Maksim Volkau REPO OWNER
changed status to resolved
Fixed the orinal issue

2015-09-03
