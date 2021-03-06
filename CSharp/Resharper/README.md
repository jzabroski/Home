1. <kbd>control</kbd>+<kbd>.</kbd> - Open refactoring context menu
2. <kbd>control</kbd>+<kbd>..</kbd> - Open refactoring context menu / Apply default refactoring
3. <kbd>control</kbd>+<kbd>alt</kbd>+<kbd>space</kbd> - "Use smart completion to show all" IntelliSense suggestions (inside object initializers)
4. <kbd>control</kbd>+<kbd>t</kbd> - Search for a specific type in the solution.  Includes type-ahead code completion suggestions.

# JetBrains Resharper Testing - Parallel Test Execution

Requires xunit 2.4.1

See my comment here: https://github.com/xunit/xunit/issues/318#issuecomment-781711686

See also
* https://resharper-support.jetbrains.com/hc/en-us/community/posts/205416730-Parallel-test-running-in-Resharper-with-xUnit-tests
* https://github.com/xunit/xunit/issues/1999
* https://xunit.net/docs/shared-context#collection-fixture
* https://github.com/xunit/xunit/issues/1169

# JetBrains.ReSharper.CommandLineTools

1. https://www.jetbrains.com/help/resharper/ReSharper_Command_Line_Tools.html
2. https://blog.jetbrains.com/dotnet/2018/03/01/code-cleanup-resharper-command-line-tools/
3. https://www.nuget.org/packages/JetBrains.ReSharper.CommandLineTools/2019.2.0-eap05

```powershell
cleanupcode.exe --profile="Built-in: Reformat Code"
```

# dotPeek

Online Help starting point: https://www.jetbrains.com/help/decompiler/2019.1/dotPeek_Introduction.html

## Register dotPeek with Windows Explorer
```powershell
~\AppData\Local\JetBrains\Installations\dotPeek191\dotPeek64.exe /register
```
