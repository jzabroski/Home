# Deployment

With ULLink Appia, there are some general rules to play by:

* `local_firm_id`: FIX-SPECIFIC. Required. Designates the ID of the local firm (i.e. your organization as it is known by your counterparty). UL APPIA uses the value of this attribute to populate tag 49 (SenderCompID) of all outbound FIX messages. If you are using encryption, this value must exactly match the user name of sender’s personal key for the session. The name is case sensitive.
* `remote_firm_id`: FIX-SPECIFIC. Required. Designates the ID of the remote firm (i.e. your counterparty). UL APPIA uses the value of this attribute to populate tag 56 (TargetCompID) of all outbound FIX messages. If you are using encryption, then value of this attribute must exactly match the value of the counterparty’s public key name. The name is case sensitive.

In addition, there are some unspoken rules:

If you're doing a parallel cutover with ability to rollback, you will need each broker to expect an additional [Tag 115 OnBeHalfOfCompID](https://www.onixs.biz/fix-dictionary/4.2/tagnum_115.html) values be sent from you.  This is not strictly required by FIX, but is simply how most line providers choose to run their network, as it simplifies debugging/troubleshooting requests and identifying which FIX line is having problems.  Likewise, the second FIX connection will likely also use an additional [Tag 128 DeliverToCompID](https://www.onixs.biz/fix-dictionary/4.2/tagnum_128.html) values be sent from you.

## Symbology Conventions

- Don't use [Tag 15 Currency](https://btobits.com/fixopaedia/fixdic42/tag_15_Currency_.html) for symbology, because it's not guaranteed to be on every message.  For example, it's not proper FIX to send [Tag 15 Currency](https://btobits.com/fixopaedia/fixdic42/tag_15_Currency_.html) on Cancel Order messages.  Most middleware will reject this message by default.  Instead, use [Tag 22 IDSource](https://www.onixs.biz/fix-dictionary/4.2/tagnum_22.html), [Tag 48 SecurityID](https://www.onixs.biz/fix-dictionary/4.2/tagnum_48.html), and [Tag 207](https://www.onixs.biz/fix-dictionary/4.2/tagnum_207.html).  Tag 207 is needed if using ISIN on buy-side, and your executing broker likely uses Sedol, as an ISIN can be thought of as the "stock entity" whereas the SEDOL is the "line of stock".   As of FIX 4.3, Tag 207 should be the ISO 10383 standard Market Identifier Code (see: [Appendix 6-C: Exchange Codes - ISO 10383 Market Identifier Code (MIC)](https://www.onixs.biz/fix-dictionary/4.4/app_6_c.html)).

## Currency Conventions

- Use [ISO-4217](https://en.wikipedia.org/wiki/ISO_4217) where possible.  Some legacy systems might use GBp (pence) in place of GBX. Similar problems exist for the Israeli Sheqel.

## Routing to specific venues

If your broker lets you route to a specific venue, you can test this by checking [Tag 30 LastMkt](https://www.onixs.biz/fix-dictionary/4.2/tagnum_30.html).  In the US, common values here would be EDGA, EDGX, IEXG, BATS, XNAS, ARCX

# Testing

1. https://www.fixtrading.org/implementation-guide/
2. https://www.fixtrading.org/standards/user-defined-fields/
    1. Useful to see all user-defined fields

# Market Level Allocation

https://www.londonstockexchange.com/products-and-services/reference-data/sedol-master-file/sedolmarketlevelpaper12022008.pdf

# Exchanges

https://www.cmegroup.com/confluence/display/EPICSANDBOX/Order+Status+Request

http://cdn.cboe.com/resources/membership/US_Options_FIX_Specification.pdf

https://www.nyse.com/publicdocs/nyse/markets/nyse/NYSE_CCG_FIX_Specification.pdf

https://www.nyse.com/publicdocs/NYSE_Pillar_Gateway_FIX_Protocol_Specification.pdf

https://www.otcmarkets.com/files/OTC%20Link%20ECN%20FIX%20Specification.pdf

http://www.interactivebrokers.com/download/IB_FIX_Manual.pdf

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
