# Performance

1. https://gist.github.com/sharwell/a794952cba68edde9083c4e2b66502fa
  - Use Server GC

# Toolbar Customizations

## Document Format button
1. Go to the _Tools_ menu
2. Go to the _Customize_ menu option
3. In the _Toolbars_ tab, click _New_.
4. Name the toolbar _Format Document_.
5. In the _Commands_ tab, select _Toolbar_ radio button.  In the adjacent dropdown, select _Format Document_ toolbar.
6. Click _Add Command..._.
7. In the left-hand _Categories_ listbox, select the _Edit_ value.
8. In the right-hand _Commands_ listbox, select the _Document Format_ value.
9. Click _OK_.
10. Click _Close_.

## ReSharper_ToggleSuspended

https://stackoverflow.com/questions/19048489/add-resharper-togglesuspended-as-toolbar-button



# Column Guides

https://marketplace.visualstudio.com/items?itemName=PaulHarrington.EditorGuidelines

# Export Config

Using Visual Studio Installer, you can Export your Visual Studio Configuration, which contains the full list of all Visual Studio Components you've installed.  This allows consistency, organization wide Visual Studio configurations.

From: https://docs.microsoft.com/en-us/visualstudio/install/command-line-parameter-examples?view=vs-2019#using-export

```
"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe" export --installPath "C:\VS" --config "C:\.vsconfig"
```

# Import Config

Using --config to install the workloads and components from a previously saved installation configuration file:

```
vs_professional.exe --config "C:\.vsconfig" --installPath "C:\VS"
```
Using --config to add workloads and components to an existing installation:

```
vs_professional.exe modify --installPath "C:\VS" --config "C:\.vsconfig"
```

# Plug-ins

1. [BuildVision](https://marketplace.visualstudio.com/items?itemName=stefankert.BuildVision) | [GitHub](https://github.com/StefanKert/BuildVision)
2. [Invisible Character Visualizer](https://marketplace.visualstudio.com/items?itemName=ShaneRay.InvisibleCharacterVisualizer) | [GitHub](https://github.com/shaneray/ShaneSpace.VisualStudio.InvisibleCharacterVisualizer)
3. [PaulHarrington.EditorGuidelines](https://marketplace.visualstudio.com/items?itemName=PaulHarrington.EditorGuidelines) | [GitHub](https://github.com/pharring/EditorGuidelines)
3. [CodeCleanupOnSave](https://marketplace.visualstudio.com/items?itemName=MadsKristensen.CodeCleanupOnSave)
4. [Output Enhancer](https://marketplace.visualstudio.com/items?itemName=NikolayBalakin.Outputenhancer) | [GitHub](https://github.com/nbalakin/VSOutputEnhancer)
5. [HSR Parallel Checker for C# 8 (VS 2019)](https://marketplace.visualstudio.com/items?itemName=LBHSR.HSRParallelCheckerforC7VS2017) | See also https://parallel-checker.com/
6. [FileNesting](https://github.com/madskristensen/FileNesting)
7. [TabsStudio](https://tabsstudio.com/)
