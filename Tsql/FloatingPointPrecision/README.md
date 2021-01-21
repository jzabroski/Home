[How It Works: SQL Parsing of Number(s), Numeric and Float Conversions](https://techcommunity.microsoft.com/t5/sql-server-support/how-it-works-sql-parsing-of-number-s-numeric-and-float/ba-p/316234)
by Bob Dorr

> Thinking about this more it becomes clear that the exponent can only represent approximately (2 ^ 11th = ~2048) exact values if you leave the mantissa all zeros.
> (There are special cases for NaN and Infinite states).   With a all zero mantissa the mathematics will be Exponent * 1.0 for an exact match.
> Anything outside of 1.0 for the mantissa has the possibility to vary from a strict integer, whole value.
