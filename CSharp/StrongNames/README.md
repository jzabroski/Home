1. [Still Strong-Naming your Assemblies? You do know it's 2016, right?](https://www.pedrolamas.com/2016/03/01/still-strong-naming-your-assemblies-you-do-know-its-2016-right/)

Key takeaways:
- Strong names can be bypassed through Assembly Binding Redirection
- Silverlight and Windows Phone did not support Assembly Binding Redirection
- All SL and WP developers got "locked out" out their favorite libraries
- Microsoft recommended as solution to open source the strong name key
- This is okay, because you should be using Authenticode instead.

> # In comes Silverlight and Windows Phone
> Unfortunately, neither Silverlight nor Windows Phone support Assembly Binding Redirection… and that is where the true problems started.
> 
> There are quite a few threads around this issue over the internet, and in the end, a lot of 3rd party library developers just decided to stop strong-naming their assemblies!
> 
> Others, followed the advice of the MSDN article I pointed above:
> 
> > If you are an open-source developer and you want the identity benefits of a strong-named assembly, consider checking in the private key associated with an assembly into your source control system.
> 
> Obviously, for this to work you would have to build your own versions of your project dependencies… and let’s be honest here: that will eventually be more of a problem that a solution.
> [...]
> # If it is such a bad thing, why are people still doing it?
> Developers seem to have the wrong notion that they should strong-name their assemblies as a security feature, but this could not be further away from the truth!
> 
> Granted, that does provide a basic insurance that an assembly hasn’t been tampered/altered, but in any case one can always use binding redirection (when available) to bypass the whole thing, so that is just a lame excuse to not buy a proper Code Signing Certificate and apply Authenticode to the assembly (which will prevent tampering AND impersonation, the right way!).
