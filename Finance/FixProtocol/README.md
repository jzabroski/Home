# Testing

https://www.fixtrading.org/implementation-guide/

# Using PerfView to View FIX Log Files

1. Open `PerfView64.exe`
2. Go to `File` -> `User Command` <kbd>ALT</kbd>+<kbd>U</kbd>
3. Enter `TextHistogram .\yourfixlog.log`
4. In the GroupPats textbox, Enter `@.*\u0001-> PREFIX $1`

# Using C# to Parse FIX Log Files

```c#
var lines = input.Split('\n');
var separator = '\u0001';
foreach (var line in lines)
{
	var matches = Regex.Match(line, @"^(?<TagValues>.*)$");
	if (matches.Success)
	{
		var tagValues = matches.Groups[1].Value.Split(separator);
		foreach (var tagValue in tagValues)
		{
			Console.WriteLine(tagValue);
		}
		Console.WriteLine("****");
	}
	//matches.Dump();
}
```
