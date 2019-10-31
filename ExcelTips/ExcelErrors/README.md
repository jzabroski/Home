### GetCustomUI for RibbonID Microsoft.Excel.Workbook Error

From: http://rockpaperweb.com/resolve-the-getcustomui-for-ribbonid-microsoft-excel-workbook-error/
> 1. Open Excel in Administrator mode
> 2. Activate the Developer tab
>    > In the workbook file menu select “Options” and in the Options menu select “Customize Ribbon”.
>    > In the right hand list of the Ribbon Customizer you should see a list of tabs.  Make sure the “Developer” tab is selected.
>    > Click OK to close the Customizer
> 3. Turn off the “Visual Studio Tools for Office Design-Time Adaptor for Excel”
>    > In the Developer tab select the “COM Add-Ins”
>    > In the COM Add-Ins dialogue look for the “Visual Studio Tools of Office Design-Time Adaptor for Excel” add in.
>    > You’ll likely see one for every version of Visual Studio that you’ve installed on this particular machine.
>    > Uncheck all of them and click OK out of the dialogue
