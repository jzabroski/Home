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

# Problems with Matching, Generally

1. Forward currency contracts, deliverable and non-deliverable, are non-standard, unlisted contracts.
2. Credit default swaps are unlisted contracts without standard identifiers
3. Money markets are ssentially cash. Typically no standard identifiers.
4. Futures don't typically have standard identifiers, outside their exchange tickers.
