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
  <ItemGroup>
    
  </ItemGroup>
  <Target Name="Example">
    <CreateItem Include="@(Item1)" 
                AdditionalMetadata="PropertyName=PropertyValue" 
                Condition="%(EnvironmentSpecific.Identity) == 'EnvironmentName1'">
      <Output ItemName="Arguments" TaskParameter="Include" />
    </CreateItem>
  </Target>
```
