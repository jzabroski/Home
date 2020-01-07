# FIX Basics

## Security Identification
FIX field 55 (Symbol) in FIX is still a very common method for security identification but this may not always be the best choice. A preferred alternative is to use a combination of fields 22 (SecurityIDSource) and 48 (SecurityID) which allow using any of a number of global security identification databases. ISIN, CUSIP, SEDOL, Bloomberg, RIC, all of them are supported.

Field 107 (SecurityDesc) can also be used to describe the security for manual trades, and field 207 (SecurityExchange) allows for indicating the market from where security indentification was taken. FIeld 167 (SecurityType) in FIX can carry the type of stock (i.e. preferred stock) or CFICode for a futures product.

## Order and venue identification

Buy-side firms identify their orders using Client Order ID field 11 (`ClOrdID`) but brokers use field 37 (OrderID). When requesting amendments or cancellations of an order, Original Client Order ID field 41 (OrigClOrdID) comes into play and chains ClOrdID of new trading instruction with the existing one being amended or cancelled.

In multi-market environments, buy-side institutions can indicate the market where order should be executed by providing its Market Identifier COde (MIC) in Execution Destination field 100 (ExDestination). In execution reports provided by sell-side firms, field 30 (LastMkt) is used to indicate the market where the order, or part of it, was filled.

Sell-side firms may also use field 851 (LastLiquidityIndicator) to indicate whether current fill was result of a liquidity provider providing or liquidity taker taking the liquidity.

Field 39 (OrdStatus) exists in all execution report messages so that sell-side firms can indicate the latest status of the order in their system.

## Quantities

Buy-side institutions use Order Quantity field 38 (OrdQty) to specify the number of units of a security they wish to buy or sell. Quantity can also be provided as cash value - e.g. for FX trades - in field 152 (CashOrdQty). For CIVs, quantity is provided in field 516 (OrderPercent).

FIX protocol also contains fields for brokers to provide changing quantity information to the buy-side during order execution.Field 32 (LastQty) carries quantity executed in current fill, 151 (LeavesQty) contains quantity open for execution, and 14 (CumQty) has the quantity executed in current order so far.

## Prices

In FIX, price for a limit order is provided in field 44 (Price) and associated currency can be indicated in 15 (Currency) field.  There is also tag 99 (StopPx) which is used to provide stop price of appropriate order types.  In execution reports, sell-side firms use field 31 (LastPx) to indicate the price at which quantity in current fill executed, and field 6 (AvgPx) to provide average price of total executed quantity in current order. Then there is field 140 (PrevClosePx) which can be used to indicate the instrument's previous day's closing price. This field is sometimes used as an aid in security identification when symbology in use does not guarantee a unique instrument.

For multi-day orders, the sell-side may use field 426 (DayAvgPx) to indicate average price of quantity filled during current day. And if they have made any price improvement, they can send its value in field 639 (PriceImprovement).

For trades which are executed in one currency and settled in another, field 120 (SettlCurrency) indicates the currency in which those should be settled.

## Execution Management

FIX protocol supports various order types, and buy-side institutions can use field 40 (OrdType) to indicate the appropraite one for their orders.   Order side is provided in field 54 (Side).

Buy-side institutions can also instruct their brokers how they should work on the order by using fields 21 (HandInst) and 18 (ExecInst). Field 21 carries general handling instruction of the order (automatic vs. manual) while field 18 allows for provision of one or more specific execution instructions - for example "All or none", "Stay on bid-side", "Go along" or "Cancel on trading halt" etc.

FIX also allows the buy-side to control how their order should be displayed in the order books of the trading floor.  Field 111 (MaxFloor) is used to indicate the quantity which will be visible on the trading floor at any given time, and 210 (MaxShow) indicates the maximum quantity which a broker can show to their other customers. The latter is useful in IOI flows as it restricts brokers to not fully disclose an order's quantity in the IOIs they may send to their other customers.

Other useful tags for execution management are 110 (MinQty) - minimum quantity in the order which must be executed, 114 (LocateReqd) - if a broker is required to locate the stock for short sell orders, 847 (TargetStrategy) - name of strategy if order is for one e.g. VWAP, 848 (TargetStrategyParameters), 839 (ParticipationRate) - if target strategy is "Participate", and 636 (WorkingIndicator) - a flag sent by a broker to indicate they are currently working on the order.

## Date and time

FIX protocl has the following fields for carrying different date/time information in orders and execution reports. Note that most date/time fields in FIX use UTC/GMT times.

* 60 (TransactTime): Time when a trading instruction, e.g. an order was created in the trading system.
* 52 (SendingTime): Time when a FIX message was sent out by the FIX engine.
* 59 (TimeInForce): Effective time of an order. This can be Day, Good TIll Date (GTD), Good Till Cancel (GTC), Immediate or Cancel (IOC), or Fill Or Kill (FOK) etc.
* 168 (EffectiveTime): Time when instruction provided in the FIX message takes effect. For example start time for an order instruction to become active.
* 432 (ExpireTime): Time when an order expires. This is always local time, instead of UTC.
* 75 (TradeDate): Date when a trade happened. Useful when a broker is reporting trades of non-current day.

## Parties in trade
FIX also provide means to identify various parties involved in the trade, both from buy-side and a broker's perspective.  For example the buy-side institutions may use field 528 (OrderCapacity) to indicate their agency, properitary, individual or principal capacity and 529 (OrderRestrictions) to specify restrictions of an order (e.g., foreign entity, market maker).

Brokers use 29 (LastCapacity) to indicate the capacity in which they executed the order - e.g., as an agent, principal or crossing as either. If they executed the order via a third-party, they may identify it in field 76 (ExecBroker).

*FIX 4.4 and later versions also support repeating groups which carry information about all parties involved in the trade. The information which can be xchanged may comprise of party ID, source of this identification, party's role and party information like address, phone number and email address.*



# Deployment

With [Raptor FIX Engine](https://www.raptortrading.com/products-services/trading-services/), there are some general rules to play by:

* Prefer not re-using the same `ClOrdId` (FIX 4.0 Tag 11)

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
