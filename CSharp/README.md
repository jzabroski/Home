# .NET Jupyter Notebooks
https://devblogs.microsoft.com/dotnet/net-core-with-juypter-notebooks-is-here-preview-1/

[PROGRAMMING INTERACTIVE BROKERS SOCKET CLIENT API USING C# / CONSOLE – MARKET SCANNERS](http://holowczak.com/ib-api-socket-csharp-console-market-scanners/)

# .NET Core Razor SDK
```xml
<Project Sdk="Microsoft.NET.Sdk.Razor">

  <PropertyGroup>
    <TargetFramework>netcoreapp2.1</TargetFramework>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Microsoft.AspNetCore.Razor.Design" Version="2.2.0" />
	<PackageReference Include="Microsoft.AspNetCore.Mvc.Razor.Extensions" Version="2.2.0" />
  </ItemGroup>

</Project>
```

# CoreRT - Multiple OS targets

```xml
<PackageReference Include="Microsoft.DotNet.ILCompiler" Version="1.0.0-alpha-27619-01" Condition="'$(CoreRT)' == 'True'" />
```
and

```xml
  <PropertyGroup>
    <CoreRT>False</CoreRT>
  </PropertyGroup>
  <PropertyGroup Condition="'$(RuntimeIdentifier)' == 'win-x64'">
    <CoreRT>True</CoreRT>
    <DefineConstants>$(DefineConstants);_CORERT;_CORERT_WIN_X64</DefineConstants>
  </PropertyGroup>
  <PropertyGroup Condition="'$(RuntimeIdentifier)' == 'linux-x64'">
    <CoreRT>True</CoreRT>
    <DefineConstants>$(DefineConstants);_CORERT;_CORERT_LINUX_X64</DefineConstants>
  </PropertyGroup>
  <PropertyGroup Condition="'$(RuntimeIdentifier)' == 'osx-x64'">
    <CoreRT>True</CoreRT>
    <DefineConstants>$(DefineConstants);_CORERT;_CORERT_OSX_X64</DefineConstants>
  </PropertyGroup>
```
or this:
```xml
  <ItemGroup Condition="'$(RuntimeIdentifier)' == 'win-x64' or '$(RuntimeIdentifier)' == 'linux-x64' or '$(RuntimeIdentifier)' == 'osx-x64'">
    <RdXmlFile Include="Draw2D.rd.xml" />
    <PackageReference Include="Microsoft.DotNet.ILCompiler" Version="1.0.0-alpha-*" />
  </ItemGroup>
```

# The Definitive Serialization Performance Guide
https://aloiskraus.wordpress.com/2017/04/23/the-definitive-serialization-performance-guide/

https://mattwarren.org/2018/06/15/Tools-for-Exploring-.NET-Internals/

# .NET Graceful Console Termination
```csharp
class Program
{
    static async Task Main(string[] args)
    {
        // Add this to your C# console app's Main method to give yourself
        // a CancellationToken that is canceled when the user hits Ctrl+C.
        var cts = new CancellationTokenSource();
        Console.CancelKeyPress += (s, e) =>
        {
            Console.WriteLine("Canceling...");
            cts.Cancel();
            e.Cancel = true;
        };
        
        await DoSomethingAsync(cts.Token);
    }
}
```

# The Uncatchable Exception

1. Use Environment.FailFast(string) inside an Exception constructor to fail fast and know exactly which exception caused the issue.
    - See: https://netfxharmonics.com/2006/10/uncatchable-exception
2. https://docs.microsoft.com/en-us/dotnet/framework/configure-apps/file-schema/runtime/throwunobservedtaskexceptions-element
```xml
<configuration>
<runtime>
<ThrowUnobservedTaskExceptions>
```

# Tuples

1. https://www.danielcrabtree.com/blog/365/accessing-tuples-at-runtime-using-reflection
2. https://www.danielcrabtree.com/blog/99/c-sharp-7-dynamic-types-and-reflection-cannot-access-tuple-fields-by-name
3. http://mustoverride.com/tuples_names/

# Async reading

https://stackoverflow.com/a/42419159/1040437

# Garbage Collection, SO MUCH GARBAGE COLLECTION

1. https://redstone325.wordpress.com/2008/05/13/notes-on-the-clr-garbage-collector-%E8%BD%AC%E8%BD%BD/


# assemblyBindingRedirect

1. https://stackoverflow.com/a/46120907/1040437
    > Binding redirects are a .NET framework concept, there are no binding redirects on .NET Standard and .NET Core.
    >
    > However, an application (the actual .NET Framework or .NET Core application) need to resolve the files to be used. On .NET Core, this is done by generating a deps.json file based on the build input and a .NET Framework application uses binding redirects.
    >
    > If a binding redirect is necessary, they have to be added to the .NET Framework application (or library) that used the .NET Standard library.
2. https://github.com/dotnet/sdk/issues/3044
3. https://docs.microsoft.com/en-us/dotnet/core/packages#package-based-frameworks
4. https://github.com/StephenCleary/AsyncEx/issues/129#issuecomment-490903771
5. https://andrewlock.net/version-vs-versionsuffix-vs-packageversion-what-do-they-all-mean/
