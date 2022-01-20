# Dependency Confusion Attacks

https://dev.to/sharpninja/dependency-confusion-yes-it-affects-nuget-packages-too-2h2g

# How to embed dependencies as unlisted dependencies
Useful for packaging executables with Nuget's nupkg format

1. https://dev.to/wabbbit/include-both-nuget-package-references-and-project-reference-dll-using-dotnet-pack-2d8p

2. https://stackoverflow.com/questions/40396161/include-all-dependencies-using-dotnet-pack and  https://josef.codes/dotnet-pack-include-referenced-projects/

3. https://medium.com/@xavierpenya/building-nuget-packages-with-dotnet-core-943f2fa2f4ca

4. 
https://patriksvensson.se/2019/09/how-to-find-a-nuget-package-path-from-msbuild/
# How to understand nuget dependencies on target frameworks

https://docs.microsoft.com/en-us/nuget/reference/target-frameworks

# Links

1. https://www.red-gate.com/simple-talk/opinion/opinion-pieces/building-a-better-nuget/
2. https://www.waitingimpatiently.com/package-reference-nuget/
3. https://www.codemag.com/article/0207071/End-DLL-Hell-with-.NET-Version-Control-and-Code-Sharing


# Rant

> On Wed, Nov 2, 2011 at 1:20 PM, John Zabroski <johnzabroski@yahoo.com> wrote:
> 
> Great brain dump.  Thanks for sharing.
> 
> As for NuGet... I always feel like Microsoft (and its developer community) have completely refused to understand decentralized software configuration management (SCM) best practices.  What do you expect from a company where its IDE copies assemblies locally for every project.
> 
> Put simply, the concept of a SDK is dead.  The concept of the original codeplex was the first baby step to realizing that.  But NuGet is the first real step toward Microsoft (and its development community) realizing that.  Yet it's not really that great of a solution compared to what has been around in the Java world for 5+ years now (Maven, Gradle, etc.).  Project automation and SCM in .NET is not state of the art.
> 
> Here's a decent blog post that summarizes sum of my views, written by somebody else: http://www.paraesthesia.com/archive/2011/10/27/nuget-doesnt-help-me.aspx
> 
> The only way Microsoft will get better faster is if somebody from up top mandates it, because most customers are too inured with a project-specific way of thinking.
