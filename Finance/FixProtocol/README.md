# Testing

https://www.fixtrading.org/implementation-guide/

# Using PerfView to View FIX Log Files

1. Open `PerfView64.exe`
2. Go to `File` -> `User Command` <kbd>ALT</kbd>+<kbd>U</kbd>
3. Enter `TextHistogram .\yourfixlog.log`
4. In the GroupPats textbox, Enter `@.*\u0001-> PREFIX $1`
