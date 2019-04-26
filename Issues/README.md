
# On Me
1. https://github.com/Microsoft/ReportingServicesTools/pull/186
2. https://github.com/JeremySkinner/FluentValidation/issues/910
3. https://github.com/natemcmaster/xunit-extensions/issues/1
4. https://github.com/benetkiewicz/Roslinq/issues/11
5. https://github.com/devedse/Roslinq/issues/1
6. https://github.com/MicrosoftDocs/sql-docs/pull/1702 - refactor to different page based on Solomon Rutzky's feedback
7. https://github.com/select2/select2/issues/3315
8. https://github.com/LokiMidgard/NDProperty/issues/4
9. https://github.com/PowerShell/PowerShellGet/pull/444

# On Them
1. https://github.com/postmanlabs/postman-app-support/issues/3216
2. https://feedback.azure.com/forums/908035-sql-server/suggestions/33212713-restore-multiple-instance-support-for-reporting-se
3. https://github.com/MicrosoftDocs/windows-powershell-docs/issues/514
4. https://github.com/dotnet/coreclr/issues/19821
5. https://github.com/simonziegler/BlazorMessagePackTest/issues/1
6. https://github.com/rsocket/rsocket-net/issues/2
7. https://resharper-support.jetbrains.com/hc/en-us/community/posts/360003226639--Access-to-displosed-closure-false-positive-with-local-function-yield-return-inside-using
8. https://github.com/dadhi/DryIoc/issues/4
9. https://github.com/dadhi/DryIoc/issues/8
10. https://github.com/dadhi/DryIoc/issues/16
11. https://github.com/dadhi/DryIoc/issues/17
12. https://github.com/nicodeslandes/TcpMux/issues/4
13. https://github.com/fluentmigrator/fluentmigrator/issues/893
14. https://github.com/Reloaded-Project/Reloaded.Hooks/issues/1
15. https://github.com/chocolatey/choco/issues/1750
16. https://github.com/Microsoft/msbuild/issues/1309
17. https://github.com/MicrosoftDocs/Virtualization-Documentation/issues/1019
18. https://github.com/DotNetAnalyzers/ReflectionAnalyzers/issues/212

# Solved
1. https://www.sqlservercentral.com/forums/topic/mysterious-permissions-issue-select-denied-on-update#post-2867350

# In Progress

Perhaps a solution to this problem already exists. I'm starting this issue perhaps to kick-start an RFC since I am so annoyed with how bad my experience has been.  I reserve the right to update this issue with a more accurate description of all my pain points as a .NET developer integrating third party libraries.  I will try to add examples of "everything wrong with the way .NET does things", and, if I have enough free time, compare to state-of-the-art in other languages and runtimes (which I suspicion are much better).  If you want to leave a private comment, feel free to email me.

Here are some issues I have run into, and suggestions to ease use:

# Issues
* dotnet global tool experience is GAC Hell 3.0 for any tool that loads libraries from the solution/project I am working on.
  - Example: dotnet FluentMigrator global tool requires every Database Migration project to target the same PackageReference as the tool itself.  Every upgrade becomes a forklift upgrade and cannot happen incrementally, iterative and according to business priority and developer time allocated to such Software Infrastructure projects
  - Workarounds involve either making the system think a global tool is not so global (Docker Container) or using dotnet local tools:
    - Use MSBuild Project element InitialTargets and define an InstallTools target that installs a [dotnet local tool](https://github.com/dotnet/cli/issues/10288) using `--tool-path`
       - Note: InitialTargets feature is not well-known by most developers, so there probably needs to be first-class support in Visual Studio, or this experience will continue to be awful.  I just learned about this feature today.
    - Docker Container Image per solution: Mostly works, but Docker on Windows experience still lacking.  Getting better with PowerShell Core support in .NET Core 3.
       - Note: Docker Container support is still growing. Principally, the newer JIT tiered compilation/optimization features enable more scenarios for Docker containers.
       - It is obvious to me that Docker Containers also solve another nightmare problem in the .NET Core ecosystem, which is the .NET Rollforward specification.  MSBuild InitialTargets cannot solve this problem.

* .NET Standard Governance Model lacks an Operational Model for linking and loading
   - Based on https://devblogs.microsoft.com/dotnet/announcing-net-standard-2-1/ Immo's outline for how .NET Standard will work going forward
   - As Immo notes, .NET Standard targets are tightly coupled to themes, because 'This simplifies answering the question which .NET Standard a given library should depend on.".  However, it's not clear how to handle bug fixes and performance tweaks.

# Suggestions
* Repurpose Microsoft Watson Exception Tool for useful things like automatically suggesting how to fix broken dependencies
  - I have no idea what Microsoft Watson is wasted on, but the average humanoid developer needs help managing dependencies, and not just because dependencies in general are a 3SAT problem. 
  - Management at Microsoft needs to realize dependency hell is just as bad a problem security was when Michael Howard taught Microsoft developers about [Writing Secure Code](https://www.amazon.com/Writing-Secure-Second-Developer-Practices/dp/0735617228).  Dependency hell is the new corrupted memory stack.  Moreover, it will jeopardize the .NET ecosystem when CTOs have to decide between effectively rewriting their .NET Framework applications to .NET Core, or rewriting things in Rust, Java or JavaScript technologies. While I can see Microsoft tackling this problem in other ways, treating it as an overall platform support problem, such as moving Entity Framework 6 to .NET Core, I'm not smart enough to know if that approach solves all problems and provides the healthiest solution for the .NET ecosystem.

Related issues:
1. https://github.com/dotnet/standard/issues/529 - ClickOnce writes its own way to discover, package, link&load dependencies
2. https://github.com/dotnet/standard/issues/604
3. https://github.com/dotnet/standard/issues/859
4. https://github.com/Microsoft/msbuild/issues/1309

# Problems in MSBuild - why can't we AutoGenerateBindingRedirects in a DotNetCorePlugin
https://github.com/Microsoft/msbuild/blob/1e574340ca00a71678d7eb67f3f3e68d981fd994/src/Tasks/AssemblyDependency/ResolveAssemblyReference.cs#L527
