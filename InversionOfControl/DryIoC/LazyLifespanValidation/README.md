

# Wrapping a dependency in Lazy results in the loss of lifespan validation
https://web.archive.org/web/20200702150537/https://bitbucket.org/dadhi/dryioc/issues/158/wrapping-a-dependency-in-lazy-results-in
Issue #158 RESOLVED
Fyodor Soikin created an issue 2015-09-07
The following code correctly throws an exception complaining that lifespan of C is longer than lifespan of its dependency D:

```c#
    class C { public C( D d ) { } }
    class D { }

    public static void Main() {
        var c = new Container();
        c.Register<C>( reuse: Reuse.Singleton );
        c.Register<D>( reuse: Reuse.InCurrentScope );

        var scope = c.OpenScope();
        scope.Resolve<C>();
    }
```

However, the exception disappears if I change dependency resolution to Lazy:
```c#
    class C { public C( Lazy<D> d ) { } }
```
In the case of Func<T> wrapper, one could argue that this behavior is fine, and even desirable: importing factory as dependency is a common way to circumvent the lifespan mismatch.

However, this argument does not apply to lazy, because it not just defers dependency resolution, but also caches it, thus making the longer-lived component to hold on to a reference to a shorter-lived component.

Combined with issue #152, which pretty much means that one has no choice but to use Lazy every now and then, this issue becomes critical: now I am basically guaranteed to violate the scoping in some places, given a large enough application.

This issue is yet another indicator that request needs to be threaded down the dependency chain, one way or another. I have proposed one possible way in this comment.

Comments (3)
Maksim Volkau REPO OWNER
changed status to open
2015-09-07
Maksim Volkau REPO OWNER
Thanks. I think it may be fixed without major changes.

Things proposed at #152 is simply too much for v2, and much to be discussed before put into final form. I will put comments there when I done with more urgent fixes.

2015-09-07
Maksim Volkau REPO OWNER
changed status to resolved
fixed: #158: Wrapping a dependency in Lazy results in the loss of lifespan validation

→ <<cset a23b5a8615aa>>

