# Overview
Useful for:
- handling callback from a web query
- BENCHMARKING queries with BackgroundQuery = True

# Create a CLASS MODULE called clsQuery

```vba
Option Explicit

Public WithEvents MyQuery As QueryTable

Private Sub MyQuery_AfterRefresh(ByVal Success As Boolean)
  If Success Then MsgBox “Query has been refreshed.”
End Sub

Private Sub MyQuery_BeforeRefresh(Cancel As Boolean)
  If MsgBox(“Refresh query?”, vbYesNo) = vbNo Then Cancel = True
End Sub
```

# Create a STANDARD Module - Name it whatever you want

```vba
Option Explicit

Dim colQueries As New Collection

Sub InitializeQueries()

  Dim clsQ As clsQuery
  Dim WS As Worksheet
  Dim QT As QueryTable

  For Each WS In ThisWorkbook.Worksheets
    For Each QT In WS.QueryTables
      Set clsQ = New clsQuery
      Set clsQ.MyQuery = QT
      colQueries.Add clsQ
    Next QT
  Next WS

End Sub
```

# ThisWorkbook module

```vba
Option Explicit

Private Sub Workbook_Open()
  Call InitializeQueries
End Sub
```
