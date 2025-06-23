I've been upgrading some code from .NET Framework to .NET 8, and the project is _almost complete_.

The remaining challenges are coming down to some seemingly mysterious differences between the two runtimes. These differences are difficult to debug because I can't seem to load symbols to actually step-through the code on both runtimes. To me, this is exciting because it means there's new stuff for me to learn and grow as an engineer. Also, this is extremely unsettling as an engineer to see stuff break in unexplainable ways.

At a broad level, my struggle is setting breakpoints in some code. Visual Stuido UI even hints at ways to overcome this problem. I've tried explicitly going to Debug > Windows > Modules and loading the associated modules. I've tried clicking on Settings and checking "Allow the source code to be different from the original". I've tried upgrading to the very latest RTM version of Visual Studio 2022 (17.14.5).

The issues are:

1. Convert.ChangeType seems to behave differently across the two platforms when using delegates/lambda expressions/expression trees as value and conversionType parameters.
    1. I've worked around this particular issue by using expression visitors to re-write the tree - so, it's not a blocker, but still, very unsettling.
    2. I've messaged Tanner Gooding on X hoping he sees it and replies. Given he worked on the numeric generic alternative to Convert.ChangeType, he seems like the best expert here to ask about the differences.
    3. I'm getting closer to creating a SSCCE (short, self-contained, correct (compilable), example) but not there yet.
    4. A combination of Google Gemini 2.5 Deep Thinking and Claude 4 Sonnet suggest the new .NET Runtime is much more strict about casts between generic types, but I actually don't even understand how the call was working on .NET 4.8 given the referencesource shows LambdaExpression, Func<,> and Expression all do not implement IConvertible.
    5. I think part of the challenge here may be the Visual Studio Debugging interface is overlaying non-helpful debug strings on things that may be masking the real issue.
2. System.Data.Entity.InternalEntityEntry.State property cannot have a breakpoint set (screenshot below).
    1. Never failed in net4.8 (>1,000,000 sample unit test runs).
    2. net8.0, 3 times in 50 builds, I got a unit test failure: System.InvalidOperationException : Saving or accepting changes failed because more than one entity of type 'Entities.Users.User' have the same primary key value. Ensure that explicitly set primary key values are unique. Ensure that database-generated primary keys are configured correctly in the database and in the Entity Framework model. Use the Entity Designer for Database First/Model First configuration. Use the 'HasDatabaseGeneratedOption" fluent API or 'DatabaseGeneratedAttribute' for Code First configuration.
    3. On net48, I have a randomized, concolic unit test that has never failed in 8 years (>1,000,000 test runs). On net8.0, it has now failed 3 times in the last 50 builds. Since it's a unit test, I altered the failing line slightly to wrap it in a try { /* failing code */ } catch (Exception ex) { System.Diagnostics.Debugger.Launch(); } and configured ReSharper to run this test until failure. After about 100,000 runs over the weekend, I was able to finally get it to hit the Launch() command. However, I cannot step into the offending code that is throwing - System.Data.Entity.InternalEntityEntry.State.
    4. I didn't think of it at the time, but I plan to instrument my DbContext with AllListeners and try again (probably next weekend) https://github.com/jzabroski/Home/blob/6fdaf3ad777cdfce4028aef5e7fff40073a846be/EntityFramework/Core/DebuggingTrick/README.md?plain=1#L52
    5. The only way I can think of to debug this code is to: (1) clone dotnet/ef6 github repository (2) add a new project under /tests folder JohnsUnitTests.csproj (2) alter EntityFramework.csproj and add <InternalsVisibleTo Include="JohnsUnitTests" /> (3) create a unit test that tries to recreate the problem.
    6. This might take weeks of running unattended to find the bug.
  
![image](https://github.com/user-attachments/assets/646b4285-1162-46dd-9394-b833b65041e2)
