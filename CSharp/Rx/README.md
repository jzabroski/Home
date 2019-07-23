In PowerShell OneGet repository, there is a ReEnumerable concept:

https://github.com/OneGet/oneget/blob/173df840e345d0a753dd0a9dec684e394f1b22ea/src/Microsoft.PackageManagement/Utility/Collections/EnumerableExtensions.cs#L22

> A ReEnumerable is a wrapper around an enumerable which timidly (cautiously) pulls items but still allows you to to re-enumerate without re-running the query.
