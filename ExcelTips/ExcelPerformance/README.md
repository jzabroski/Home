Community Tips: https://answers.microsoft.com/en-us/msoffice/forum/all/common-excel-performance-issues-and-solutions/0205f4b4-a10c-43c5-ae8f-140b77bdee91

https://techcommunity.microsoft.com/t5/Excel-Blog/Excel-performance-improvements-now-take-seconds-running-Lookup/ba-p/254199

1. [Office Products Troubleshooting/Excel/How to clean up an Excel workbook so that it uses less memory](https://docs.microsoft.com/en-us/office/troubleshoot/excel/clean-workbook-less-memory)
   1. Formatting considerations
      1. Eliminate excessive formatting
         - To eliminate excess formatting, use the format cleaner add-in that is available in [Clean excess cell formatting on a worksheet](https://support.office.com/article/clean-excess-cell-formatting-on-a-worksheet-e744c248-6925-4e77-9d49-4874f7474738).
      2. Remove unused styles
         - Many utilities are available that remove unused styles. As long as you are using an XML-based Excel workbook (that is, an .xlsx file or an. xlsm file), you can use the style cleaner tool. You can find this [tool](https://sergeig888.wordpress.com/2011/03/21/net4-0-version-of-the-xlstylestool-is-now-available/) here.
         - Some open source libraries, like ClosedXML, accidentally created duplicate styles: 
             1. https://github.com/ClosedXML/ClosedXML/commit/d20bd7b4d435494b91b42749f2a22aea13df5a35
             2. https://github.com/ClosedXML/ClosedXML/commit/cf782378dc09d4d0413a79a6fce4181789c31010
      3. Remove shapes
      4. If you continue to experience issues after you remove shapes, you should examine considerations that are not related to formatting.
      5. Remove conditional formatting
         - If removing conditional formatting resolves the issue, you can open the original workbook, remove conditional formatting, and then reapply it.
   2. Calculation considerations
      1. Opening an Excel Workbook for the first time in a new version of Excel may take a long time if the workbook contains lots of calculations. To open the workbook for the first time, Excel has to recalculate the workbook and verify the values in the workbook.
         - [Workbook loads slowly the first time that it is opened in Excel](https://support.microsoft.com/help/210162)
         - [External links may be updated when you open a workbook that was last saved in an earlier version of Excel](https://support.microsoft.com/help/925893)
      2. Formulas
          - xlsx files have much larger grid size.
              - The grid size grew from 65,536 rows to 1,048,576 rows and from 256 (IV) columns to 16,384 (XFD) columns.  
              - Therefore, formulas that reference unbound ranges in the grid will become exponentially more expensive.  
          - Array Formulas, such as:
              * LOOKUP
              * INDIRECT 
              * OFFSETS
              * INDEX
              * MATCH
         
2. https://superuser.com/questions/447264/diagnosing-slow-excel-spreadsheets
3. https://fastexcel.wordpress.com/2017/03/13/excel-javascript-api-part-2-benchmark-of-readwrite-range-performance/
   1. See also: https://docs.microsoft.com/en-us/javascript/api/excel/excel.application?view=excel-js-preview
   2. See also: https://stackoverflow.com/questions/41382040/why-does-this-context-sync-not-work - may be best to move this to Excel-JS API section
4. https://docs.google.com/document/d/1T9CCux05aRZIuM1PTy1fwGz9_IoIxjjx2lVwfpvqYuw/edit


https://sites.google.com/site/beyondexcel/project-updates/needforspeed
