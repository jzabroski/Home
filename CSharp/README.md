.NET Core Razor SDK
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

https://www.danielcrabtree.com/blog/365/accessing-tuples-at-runtime-using-reflection
