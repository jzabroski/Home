1. https://dzone.com/articles/create-a-simple-parser-in-c-with-sprache
2. https://www.codeproject.com/Articles/795056/Sprache-Calc-Building-Yet-Another-Expression-Evalu
3. https://nblumhardt.com/2010/01/building-an-external-dsl-in-c/

```c#
public class MyParser
{
	public static readonly Parser<string> QuotedText =
		(from openQuote in Parse.Char('"')
		 from textContent in Parse.CharExcept('"').Many().Text()
		 from closeQuote in Parse.Char('"')
		 select textContent).Token();
	public static void Main()
	{
		// Should throw ParseException.
		//Console.WriteLine(MyParser.Assignable.Parse("1"));
		//Console.WriteLine(MyParser.Assignable.Parse("result = 1"));
		Console.WriteLine(MyParser.QuotedText.Parse("\"success\""));
		try
		{
			Console.WriteLine(MyParser.QuotedText.Parse("\"")); // fail
		}
		catch (Exception ex)
		{
			Console.WriteLine(ex);
		}
		try
		{
			var result = MyParser.QuotedText.Parse("\"\"");
			Console.WriteLine((result == "") ? "empty" : result); // fail
		}
		catch (Exception ex)
		{
			Console.WriteLine(ex);
		}
	}
	
}
```
