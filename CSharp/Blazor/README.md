
1. [Blazor.Cordova - Lukas Bickel](https://medium.com/@bickellukas98/blazor-cordova-a3b0a6c3bf10)
tl;dr: See https://github.com/BickelLukas/Blazor.Cordova

> # Fixing the path problem
> It looks like our files are not loading. Probably a problem with absolute paths. So let’s remove the following line from index.html:
> ```
> <base href="/" />
> ```

> Create a file called Blazor.Cordova.props and paste in the following content.
> ```xml
> <Project>
>   <PropertyGroup Label="Blazor build outputs">
>     <BaseBlazorDistPath>dist/</BaseBlazorDistPath>
>     <BaseBlazorPackageContentOutputPath>$(BaseBlazorDistPath)content/</BaseBlazorPackageContentOutputPath>
>     <BaseBlazorRuntimeOutputPath>$(BaseBlazorDistPath)framework/</BaseBlazorRuntimeOutputPath>
>     <BaseBlazorRuntimeBinOutputPath>$(BaseBlazorRuntimeOutputPath)bin/</BaseBlazorRuntimeBinOutputPath>
>     <BaseBlazorRuntimeAsmjsOutputPath>$(BaseBlazorRuntimeOutputPath)asmjs/</BaseBlazorRuntimeAsmjsOutputPath>
>     <BaseBlazorRuntimeWasmOutputPath>$(BaseBlazorRuntimeOutputPath)wasm/</BaseBlazorRuntimeWasmOutputPath>
>     <BaseBlazorJsOutputPath>$(BaseBlazorRuntimeOutputPath)</BaseBlazorJsOutputPath>
>     <BaseBlazorIntermediateOutputPath>blazor/</BaseBlazorIntermediateOutputPath>
>     <BlazorWebRootName>wwwroot/</BlazorWebRootName>
>     <BlazorBootJsonOutputPath>$(BaseBlazorRuntimeOutputPath)$(BlazorBootJsonName)</BlazorBootJsonOutputPath>
>   </PropertyGroup>
> </Project>
> ```

> add a reference to this file for it to get used during build. Add the following line to the blazor.csproj file.
> ```xml
> <Import Project="Blazor.Cordova.props" />
> ```

> modify index.html to reference the right path.
> ```html
> <script src="framework/blazor.webassembly.js"></script>
> ```
