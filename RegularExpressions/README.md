# Papers

http://www.dfrws.org/sites/default/files/session-files/paper-unicode_search_of_dirty_data_or_how_i_learned_to_stop_worrying_and_love_unicode_technical_standard_18.pdf

# Any New Line

Here is a GitHub markdown translation of Jeffrey Freidl's Mastering Regular Expressions (2002) coverage of "any new line":

## Table 3-11 Line Anchors for Some Scripting Languages

| Concern    | Java  | Perl | PHP  | Python   | Ruby   | Tcl | .NET  |
| ---------- | ----- | ---- | ---- | -------- | ------ | --- | ----- |
| Normally...|       |      |      |          |        |     |       |
| ^ matches at start of string | ✓ | ✓ | ✓ | ✓ |  ✓ | ✓ | ✓ |
| ^ matches after any new line | ✗ | ✗ | ✗ | ✗ | ✓<sub>2</sub> | ✗ | ✗ |
| $ matches at end of string |  ✓<sub>1</sub> | ✓ | ✓ | ✓ | ✓ | ✗ | ✓ |
| $ matches before string-ending newline | ✓ | ✓ | ✓ | ✓ | ✓<sub>2</sub> | ✗ | ✓ |
| $ matches before any newline | ✗ | ✗| ✗ | ✗ | ✓<sub>2</sub> | ✗ | ✗ |
| Has enhanced line-anchor mode (ex 111) | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ | ✓ |
| In enhanced line-anchor mode... | | | | | | | |
| ^ matches at start of string | ✓ | ✓ | ✓ | ✓ | N/A | ✓ | ✓ |
| ^ matches after any newline | ✓<sub>1</sub> | ✓ | ✓ | ✓ | N/A | ✓ | ✓ |
| $ matches at end of string | ✓ | ✓ | ✓ | ✓ | N/A | ✓ | ✓ |
| $ matches after any newline | ✓<sub>1</sub> | ✓ | ✓ | ✓ | N/A | ✓ | ✓ |
| \A always matches like normal ^ | ✓ | ✓ | ✓ | ✓ | •<sub>4</sub> | ✓ | ✓ |
| \Z always matches like normal $ | ✓<sub>1</sub> |  ✓ | ✓  | •<sub>3</sub> |  •<sub>5</sub> |  ✓ |  ✓ |
| \z always matches only at end of string | ✓ | ✓ | ✓ |  N/A | N/A |  ✓ | ✓ |

1. Sun's java regex package supports Unicode's _line terminator (ex 108) in these cases
2. Ruby's $ and ^ match at embedded newlines, but its \A and \Z do not.
3. Python's \Z matches only at the end of the string
4. Ruby's \A, unlike its ^, matches only at the start of string
5. Ruby's \Z, unlike its $, matches only at the end of string, or before a string-ending newline.
