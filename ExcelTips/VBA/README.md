# VBA Error Handling
- Consider disabling "Enable multi-threaded processing" if you can't figure out how a Workbook is getting its result
- The behavior of "On Error GoTo 0" is augmented by the Workbook option "Show Add-in User Interface Errors" (which is disabled by default)
  - https://www.spreadsheet1.com/show-add-in-user-interface-errors.html
- https://excelmacromastery.com/vba-error-handling/#On_Error_GoTo_0
  > ### On Error GoTo 0
  > This is the default behavior of VBA. In other words, if you don’t use On Error then this is the behavior you will see.
  > [...]
  > This behavior is unsuitable for an application that you are given to a user. These errors look unprofessional and they make the application look unstable.
  > 
  > An error like this is essentially the application crashing. The user cannot continue on without restarting the application. They may not use it at all until you fix the error for them.
  > 
  > By using On Error GoTo [label] we can give the user a more controlled error message. It also prevents the application stopping. We can get the application to perform in a predefined manner.
