# Compiling a US Equities Security Master every morning

https://medium.com/prooftrading/proof-engineering-security-master-4e2ac164511f

# OpenFIGI Symbology Crosswalk Tutorials

https://www.lemon.markets/blog/mapping-a-ticker-symbol-to-isin-using-openfigi-and-lemonmarkets

# OMG: How FIGI Relates to other Standards
https://issues.omg.org/issues/FIGI-20

> FIGI, while a stand-alone standard, is seemingly related to other standards in the Finance space. In particular, ISO 6166 (ISIN), ISO 10962 (CFI), and ISO 20022 (UNIFI) seem much more closely related to FIGI than others. This item calls for some explicit treatment of if and how FIGI relates to these standards and any restrictions in place regarding possible mappings to those standards.

# FIGI Allocation Rules
https://www.openfigi.com/assets/local/figi-allocation-rules.pdf

# Preferred Symbol Names
From: https://www.quantumonline.com/PfdSymbolsNames.cfm

> | Quote Source   | Preferred Designator | Alabama Power 5.20% Pfd Stk | ABC Bancorp 9.00% Pfd Sec | Citigroup Capital IX 6% TruPS |
> | -------------- | -------------------- | --------------------------- | ------------------------- | ----------------------------- |
> | QuantumOnline  |	-	                  | ALP-N                       | BHC-                      | C-S                           |
> | S&P            | -                    | ALP-N                       | BHC-                      | C-S                           |
> | NYSE           | PR                   | ALPPRN                      | BHCPR                     | CPRS                          |
> | NYSE Amex      | p                    | ALPpN                       | BHCp                      | CpS                           |
> | Bloomberg      | /P                   | ALP/PN                      | BHC/P                     | C/PS                          |
> | Charles Schwab | /PR+                 | ALP/PRN <br/> ALP+N         | BHC/PR <br/> BHC+         | C/PRS <br/>C+S                |
> | E-Trade        | p                    | ALPpN                       | BHCp                      | CpS                           |
> | Fidelity       | PR                   | ALPPRN                      | BHCPR                     | CPRS                          |
> | Google Finance | -                    | ALP-N                       | BHC-                      | C-S                           |
> | JPMorgan       | PR                   | ALP PRN                     | BHC PR                    | C PRS                         |
> | LPL Financial	 | '                    | ALP'N                       | BHC'                      | C'S                           |
> | MarketWatch    | .PR                  | ALP.PRN                     | BHC.PR                    | C.PRS                         |
> | Quicken        | PR                   | ALP PRN                     | BHC PR                    | C PRS                         |
> | ScotTrade      | p                    | ALPpN                       | BHCp                      | CpS                           |
> | TD Ameritrade  | -                    | ALP-N                       | BHC-                      | C-S                           |
> | Vanguard       | \_p                  | ALP_pN                      | BHC_p                     | C_pS                          |
> | Yahoo!         | -p                   | ALP-pN                      | BHC-p                     | C-pS                          |

# Problems with using SEDOL for Matching

Bloomberg does not always issue a different ticket for each SEDOL and security/exchange. For instance, FSV U PDF (FirstService Corporation, CA33761N2086) has two SEDOLs:

1. B23GH30 in Canada
2. B23TF27 in the US

# Problems with using ISINs for Matching Derivative Contracts under MiFid II

While CFTC started Project KISS in 2017, in 2018, many vendors were racing to comply with MiFiD II Price Transparency rules, and so a lot of vendors jammed ISINs into ANNA-DSB registration portal.

https://www.clarusft.com/mifid-ii-why-isins-for-otc-derivatives-are-bad-for-transparency/

ANNA-DSB is the organization that mints ISINs for Derivatives regulated by MiFiD II. They have a DSB GUI for viewing ISINs, here: https://prod.anna-dsb.com/

1. ISIN for an IRS. Uses Maturity Date instead of Tenor Period.
2. It is non-trivial to compare the price of a 10Y EUR IRS across venues on the same business day. And makes it even hard to build a historical time-series of the price of a 10Y EUR IRS.
    1. There is an Expiry date field with 2028-01-10, a Reference Rate EURIBOR and Reference Term of 6 months.
    2. So I would have to assume that if this was traded on 8 Jan 2018, then it is a standard spot starting 10Y EUR IRS Fixed vs Euribor 6M, the market standard trade and one of the largest OTC derivatives traded on a daily basis.
    3. And on 9 Jan 2018, I would need to look for a different ISIN with expiry date of 2028-01-11 and on 10 Jan 2018 for one with an expiry date of 2028-01-12 and so on.
3. If we want to compare prices between Trade Venues, then we need to know that the interest rate swap we are looking at is the same on each venue.
4. But to do that we need other fields that are simply not in the static data for this ISIN:
  * Bi-lateral or Cleared, which differ in price
  * CCP, an EUR IRS has a different price at LCH, Eurex or CME
  * With one date only, how do we know which are Forward Start Swaps, as a 5Y5Y would have the same expiry date as a 10Y, but a very different price. Do we rely on the text in the name?
5. How do we know which of these is assumed by the ISIN created by a Venue.
6. Indeed how does another Venue know what the creating Venue meant in order to decide whether to use an ISIN or create a new one.

# Problems with Matching, Generally

1. Forward currency contracts, deliverable and non-deliverable, are non-standard, unlisted contracts.
2. Credit default swaps are unlisted contracts without standard identifiers
3. Money markets are ssentially cash. Typically no standard identifiers.
4. Futures don't typically have standard identifiers, outside their exchange tickers.
