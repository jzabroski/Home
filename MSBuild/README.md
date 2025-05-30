# Chasing an MSBuild task devenv.exe file lock
https://jaylee.org/archive/2019/01/18/chasing-an-msbuild-task-lock.html

# Claire Novotny's DeterministicBuild

https://github.com/clairernovotny/DeterministicBuilds

# Nate McMaster's MSBuild Task with Dependencies

https://natemcmaster.com/blog/2017/11/11/msbuild-task-with-dependencies/

# Daniel Cazzulino's Building like a Pro: A Primer

http://www.cazzulino.com/building-like-a-pro-primer.html

# Xamarin FAQ on MSBuild Best Practices

https://github.com/dotnet/android/blob/main/Documentation/guides/MSBuildBestPractices.md

# Stephen Cleary: Filtering an ItemGroup Based on a Property

https://blog.stephencleary.com/2009/05/msbuild-filtering-itemgroup-based-on.html

# Web.config Transformation Syntax for Web Project Deployment Using Visual Studio
https://docs.microsoft.com/en-us/previous-versions/aspnet/dd465326(v=vs.110)?redirectedfrom=MSDN

# MSBuild Metadata Tips

1. Metadata is only one level deep
    1. Therefore, given:
        ```xml
        <A>
          <B>
            <C>
            </C>
          </B>
        </A>
        ```
        You can't write: `%(%(A.B).C)` or similar expressions.
2. Batching is not equivalent to looping (see below on "Double Batching")
   1. If you reference two Item groups in the same task, Msbuild will batch on them both separately. which is NOT what you want.
   2. Therefore, in the same MSBuild Task, you cannot refer to two different ItemGroup expressions in the same `Properties` expression.

# Double Batching / Double Loop / Join Two ItemGroups together
This is useful for flattening a deeply nested collection of XML elements:
```xml
  <Level1 Include="A">
    <Level2>
      <Level3>true</Level3>
    </Level2>
  </Level1>
```

1. https://theflightlessgeek.co.nz/thoughts/2015/3/8/getting-the-combination-of-two-itemgroups-in-msbuild
2. https://web.archive.org/web/20160113173520/http://blogs.msdn.com/b/giuliov/archive/2010/04/30/gotcha-msbuild-nested-loops-double-batching.aspx

# Understanding MSBuild Batching Behavior

1. https://github.com/microsoft/msbuild/issues/4429#issuecomment-500609578

> This is partially a result of the intensely confusing behavior that the MSPress MSBuild book calls "multi-batching". This is somewhat documented under no particularly clear name at https://docs.microsoft.com/en-us/visualstudio/msbuild/item-metadata-in-task-batching?view=vs-2019#divide-several-item-lists-into-batches.
> 
> Basically, if you have a single batch-eligible thing (here let's just say task invocation; pretty sure this works for target batching too) with multiple item lists, a bare metadata reference like %(Filename) applies to _all lists simultaneously_.

# Intersection of Two ItemGroup sub-groups (filter each ItemGroup on identity)
Use CreateItem task and output the value you need:

```xml
  <ItemGroup>
    <EnvironmentSpecific Include="EnvironmentName1">
      <HomePage>http://www.google.com</HomePage>
    </EnvironmentSpecific>
    <EnvironmentSpecific Include="EnvironmentName2">
      <HomePage>http://www.bing.com</HomePage>
    </EnvironmentSpecific>
  </ItemGroup>
  <Target Name="Example">
    <CreateItem Include="@(Item1)" 
                AdditionalMetadata="PropertyName=PropertyValue" 
                Condition="%(EnvironmentSpecific.Identity) == 'EnvironmentName1'">
      <Output ItemName="Arguments" TaskParameter="Include" />
    </CreateItem>
  </Target>
```

# Build-time Code Generation

https://mhut.ch/journal/2015/06/30/build-time-code-generation-in-msbuild#live-update-on-project-change

There are two possible ways to tell Roslyn Language Services that a generator should run:

1. Live Update on Project Change
2. Live Update on File Change

## Live Update on Project Change
> So how do the types from the generated file show up in code completion before the project has been compiled? This takes advantage of the way that Visual Studio initializes its in-process compiler that’s used for code completion.
> 
> When the project is loaded in Visual Studio, or when the project file is changed, Visual Studio runs the `CoreCompile` target. It intercepts the call to the compiler via a host hook in the the MSBuild `Csc` task and uses the file list and arguments to initialize the in-process compiler.

## Live Update on File Change

> So, the generated code is updated whenever the project changes. But what happens when the contents of the ResourceFile files that it depends on change?
> 
> This is handled via Generator metadata on each of the ResourceFile files:
> 
> ```xml
> <ItemGroup>
>   <ResourceFile Include="Foo.png">
>     <Generator>MSBuild:UpdateGeneratedFiles</Generator>
>   </ResourceFile>
> </ItemGroup>
> ```
> 
> This takes advantage of another Visual Studio feature. Whenever the file is saved, VS runs the UpdateGeneratedFiles target. The code completion system detects the change to the generated file and reparses it.
