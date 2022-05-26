
# Context-dependent resolution only works for the very first context

https://web.archive.org/web/20200702150532/https://bitbucket.org/dadhi/dryioc/issues/153/context-dependent-resolution-only-works

Issue #153 RESOLVED
Fyodor Soikin created an issue 2015-08-27
According to this article, here's a test setup:

```c#
class Str { public string S; }

class C {
    public Str S;
    public C( Str s ) { S = s; }
}

class D
{
    public Str S;
    public D( Str s ) { S = s; }
}

public static void Main() {

    var c = new Container();
    c.Register<C>();
    c.Register<D>();
    c.Register( Made.Of( () => new Str { S = Arg.Index<string>( 0 ) }, r => r.Parent.ImplementationType.Name ) );

    var x = c.Resolve<C>();
    var y = c.Resolve<D>();

    Console.WriteLine( x.S.S ); // Prints "C"
    Console.WriteLine( y.S.S ); // Prints "C"
}
```

Both WriteLine statements at the end print `"C"` instead of expected output of `"C"` and `"D"`.
This happens because the expression for `Str` gets cached after first resolution, capturing `"C"` as the value of property `S`.

After reading the aforementioned article, I have come to expect that the values for `Arg.Index<T>` would be evaluated on each resolution given that particular request, and then passed to the expression as parameters, which would have made total sense.
But apparently that is not how it works: arguments get evaluated only once, during expression tree construction, and then remain baked into the expression tree forever.

From the previous point, one might conclude that one should be able to get around this by prohibiting expression caching. And sure enough, the following works:

```c#
    c.Register( 
        Made.Of( () => new Str { S = Arg.Index<string>( 0 ) }, r => r.Parent.ImplementationType.Name ),
        setup: Setup.With( cacheFactoryExpression: false ) );
```

This workaround seems to be ok in our particular case (which is injection of the logger), but will not apply in general case, because with caching prohibited the expression might end up being reconstructed and recompiled on every instantiation, causing memory leak and performance degradation.

Comments (4)
Maksim Volkau REPO OWNER

Hi Fyodor,

First, yes it should be marked as non cached to work in all contexts. I will fix the example and documentation.

Another idea, is to automatically turn off caching when context based setup is provided. That will be more ideal. Will play with that.

Also, what is exactly considered as memory leak here?

As for perf: `C` and `D` expressions still will be constructed once and cached.

Thanks,
Maksim

2015-08-27
Fyodor Soikin REPORTER

If I register the dependency with disabled cache, and then have it requested somewhere through a Lazy wrapper, the expression will end up reconstructed and recompiled on every instantiation.
That's where the memory leak and performance degradation are. Check this out:

```c#
        class Str { public string S; }

        class C {
            public Lazy<Str> S;
            public C( Lazy<Str> s ) { S = s; }
        }

        class D
        {
            public Lazy<Str> S;
            public D( Lazy<Str> s ) { S = s; }
        }

        public static void Main() {

            var c = new Container();
            c.Register<C>();
            c.Register<D>();
            c.Register( 
                Made.Of( () => new Str { S = Arg.Index<string>( 0 ) }, r => r.Parent.ToString() ),
                setup: Setup.With( cacheFactoryExpression: false ) );

            var y = c.Resolve<D>();
            var x = c.Resolve<C>();
            var x2 = c.Resolve<C>();
            var x3 = c.Resolve<C>();

            Console.WriteLine( y.S.Value.S );
            Console.WriteLine( x.S.Value.S );
            Console.WriteLine( x2.S.Value.S );
            Console.WriteLine( x3.S.Value.S );
        }
```
  
This (kinda) works, but ends up calling `Factory.GetDelegateOrDefault` six times (one for `C`, one for `D`, and four for `Str`), which means six calls to Expression.Compile where only three are required. Imagine this happening on every request in a web application, and there's your leak.
Same principle as in issue #152.

I'd like to take this opportunity to reiterate once again that allowing expressions to be rebuilt on every request is a very dangerous option.
If you really need it (and I can see how it's useful in a situation like this), it should be limited to child (i.e. non-root) requests only, so that it still ends up cached as part of the parent expression. Root resolution should not be allowed to go uncached.

2015-08-27
Maksim Volkau REPO OWNER
changed status to open
2015-08-27
Maksim Volkau REPO OWNER
changed status to resolved
fixed: #153: Context-dependent resolution only works for the very first context breaking: Removing `cacheFactoryExpression` instruction from `Factory.Setup` - instead calculate if caching is feasible based on context.

→ <<cset c7f73693e107>>

2015-09-02
