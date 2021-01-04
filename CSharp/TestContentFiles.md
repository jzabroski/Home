**tl;dr:** *I see why open source project maintainers are completely dropping support for .NET Framework and some are even focusing only on .NET 5.*

I recently started using cross-platform build matrices thanks to how easy they are to set-up with GitHub Actions.  But I was surprised at how hard it was for me to write some relatively simple code to read in a cshtml file for a dynamic Razor template unit test.

Frankly, I *thought I knew how to do this*, since I had a working Travis CI Ubuntu Bionic build, and a working Windows build locally.  *Clearly*, I never realized how many implementation details lie beneath the hood of dotnet test, dotnet vstest, and so forth.  A few hours later, I realized there were implementation details I never thought of carefully, and began to wonder if my Windows-based Resharper Unit Test Session was even fixing some bad code I've written.

For example, I discovered an MSBuild issue [where CopyAlways Content does not always get copied](https://github.com/xunit/xunit/issues/1796#issuecomment-483218319).  And CopyAlways Content has been [the recommended approach by Microsoft for a decade](https://docs.microsoft.com/en-us/previous-versions/ms182475(v=vs.140)?redirectedfrom=MSDN#how-do-i-deploy-test-files-for-a-local-test), so how this got broken, I have no idea.

In the old days, we would use `Assembly.Location`, which, as the documentation states, in .NET Framework, that is the value *after* the [assembly has been shadow copied](https://docs.microsoft.com/en-us/dotnet/framework/app-domains/shadow-copy-assemblies).  Shadow copying is a trick that IDE tools like unit test runners and code coverage tools use to avoid a problem where the Common Language Runtime locks all assemblies loaded into an Application Domain.  ReSharper dotCover 
[introduced specific features to handle exactly this scenario](https://blog.jetbrains.com/dotnet/2015/12/28/shadow-copying-in-dotcover-if-your-nunit-tests-fail-during-continuous-testing/).

I've even tried to reproduce the problem by forking Andrew Lock's blog-examples repository and customizing his XunitTheoryTests folder.  But... his tests pass.  The key difference between his tests and mine is that he is using `Path.GetCurrentDirectory()` and, I have tried using various approaches, but the more I dig, the more I realize it feels somewhat futile to build a cross-platform, cross-runtime approach to simply get a directory containing my test assets.

Here are the breaking changes for .NET 5, for example.  I know, you might say, "your tests are not a bundled application".  And... I have no idea how I would even know what magic the test runner is doing.



> **File Location for Bundled Applications**  
>  
> When an application is bundled into a single file along with its dependencies, the behavior of some Reflection APIs are no longer obvious. Previously, bundled applications would have their dependencies extracted into a temporary location, so the Reflection calls would reference this. With .NET 5, those dependencies are loaded directly from memory. This means there is no physical Assembly file to reference. As such, the following APIs needed to be altered. Below are the new behaviors.  
>  
> Assembly.Location  : Returns empty string for bundled assemblies  
>  
> Assembly.CodeBase  : Throws exception for bundled assemblies  
>  
> Assembly.GetFile(String)  : Throws exception for bundled assemblies  
>  
> Environment.GetCommandLineArgs()\[0\]  : Value is the name of the host executable  
>  
> AppContext.BaseDirectory  : Value is the containing directory of the host executable

