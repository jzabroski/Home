#### Q: Is there anyway to control the sequence of function calls in a excel sheet when it is re-opened?
A: Put your initialization code in a Workbook_Open event. Otherwise, assume any sequence of function calls.
You have to be careful trying to do this, even with a carefully constructed set of false dependencies.
For example, UDFs can be evaluated more than once during a recalc. Excel generally allows itself to assume that your functions
don't have side effects that make the order of execution significant.
See http://decisionmodels.com/calcsecretsj.htm for more information.

#### Q: Does the Excel IF formula guarantee short-circuit/non-strict/lazy evaluation?


A: As far as I know, Excel does short-circuiting on IF and does not evaluate the "other part".
You should be able to check that by logging which cells call your UDF (application.caller returns a pointer to that cell):

```vba
Public Function foobar()
    Debug.Print Application.Caller.Address
End Function
```

https://techcommunity.microsoft.com/t5/Excel/Is-IF-true-false-conditions-non-strict-or-strictly-evaluated/m-p/925609
