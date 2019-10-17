1. https://dzone.com/articles/create-a-simple-parser-in-c-with-sprache
2. https://www.codeproject.com/Articles/795056/Sprache-Calc-Building-Yet-Another-Expression-Evalu
3. https://nblumhardt.com/2010/01/building-an-external-dsl-in-c/
4. http://www.magnuslindhe.com/2014/09/parsing-whitespace-and-new-lines-with-sprache/
    > In Sprache you can use the Token method to get a parser for a token that disregards any whitespace that might surround the token. This is a really helpful method for any language that allows for whitespace throughout the grammar.
    >
    > However, the Token method can not be used in a grammar where the new line characters are used as a terminator between other language constructs. The reason for this is that the Token method will swallow the new line characters as they are regarded as whitespace.
5. Using JACE.NET instead of Sprache or Sprache.Calc https://github.com/yallie/Sprache.Calc/issues/2#issuecomment-543187108
6. Problems with Sprache https://nblumhardt.com/2016/09/superpower/
    1. Only looks at one character at a time, so parsing errors are not as friendly as they should be.
    2. Nicholas Blumhardt created Superpower to replace it: https://github.com/datalust/superpower

# MyParser

```c#


public class MyParser
{
	/* This section covers grammars where the new line character
	   is used as a terminator between other language constructs. */
	public static Parser<T> WithWhiteSpace<T>(Parser<T> parser)
	{
		if (parser == null) throw new ArgumentNullException("parser");

		return from leading in Parse.WhiteSpace.Except(NewLine).Many()
			   from item in parser
			   from trailing in Parse.WhiteSpace.Except(NewLine).Many()
			   select item;
	}
	public static readonly Parser<string> NewLine = Parse
			.String(Environment.NewLine)
			.Text()
			.Named("new line");

	/* This section covers grammars where an opening and closing " (quote) symbol
	   is used for string literals */
	public static readonly Parser<string> QuotedText =
		(from openQuote in Parse.Char('"')
		 from textContent in Parse.CharExcept('"').Many().Text()
		 from closeQuote in Parse.Char('"')
		 select textContent).Token();

	/* This section covers assigning a value to an assignable */
	static KeyValue SetAssignment(IEnumerable<char> lhv, IEnumerable<char> rhv)
	{
		return new KeyValue { Key = string.Join("", lhv), Value = string.Join("", rhv) };
	}
	static Parser<KeyValue> SetAssignable =
				from lhv in Parse.Letter.AtLeastOnce().Token()
				from assignmentOperator in Parse.Char('=').Token()
				from rhv in Parse.AnyChar.AtLeastOnce().Token()
				select SetAssignment(lhv, rhv);
	
	/* This section covers expressions that are return values */
	// TODO this can be improved because Parse.Decimal uses the current culture's separator character
	static Parser<string> ReturnValue = Parse.Decimal.Or(Parse.Number);
	
	public static void Main()
	{

		try
		{
			Console.WriteLine(MyParser.SetAssignable.Parse("1")); // fail
		}
		catch (Exception ex)
		{
			Console.WriteLine(ex);
		}
		Console.WriteLine(MyParser.ReturnValue.Parse("1"));
		Console.WriteLine(MyParser.ReturnValue.Parse("1.2"));
		
		Console.WriteLine(MyParser.SetAssignable.Parse("result = 1")); // returns KeyValue pair
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

class KeyValue
{
	public string Key { get; set; }
	public string Value { get; set; }

	public override string ToString()
	{
		return $"{Key} = {Value}";
	}
}
```
