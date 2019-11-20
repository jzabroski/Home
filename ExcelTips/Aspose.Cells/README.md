# Setting the License
```csharp
new Aspose.Cells.License().SetLicense("Aspose.Total.lic");
```
# Using Aspose.Cells

1. [Modifying VBA or Macro Code using Aspose.Cells](https://docs.aspose.com/display/cellsnet/Modifying+VBA+or+Macro+Code+using+Aspose.Cells)
    ```csharp
    // For complete examples and data files, please go to https://github.com/aspose-cells/Aspose.Cells-for-.NET
    // The path to the documents directory.
    string dataDir = RunExamples.GetDataDir(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

    // Create workbook object from source Excel file
    Workbook workbook = new Workbook(dataDir + "sample.xlsm");

    // Change the VBA Module Code
    foreach (VbaModule module in workbook.VbaProject.Modules)
    {
        string code = module.Codes;

        // Replace the original message with the modified message
        if (code.Contains("This is test message."))
        {
            code = code.Replace("This is test message.", "This is Aspose.Cells message.");
            module.Codes = code;
        }
    }

    // Save the output Excel file
    workbook.Save(dataDir + "output_out.xlsm");
    ```
2. [Find or Search Data](https://docs.aspose.com/display/cellsnet/Find+or+Search+Data)
    1. See also: [XLParser](https://github.com/spreadsheetlab/XLParser) for a robust Excel formula parser independent of Aspose.Cells
    2. Find in Cells Containing a Formula
        ```csharp
        // For complete examples and data files, please go to https://github.com/aspose-cells/Aspose.Cells-for-.NET
        // Opening the Excel file
        Workbook workbook = new Workbook(sourceDir + "sampleFindingCellsContainingFormula.xlsx");

        // Accessing the first worksheet in the Excel file
        Worksheet worksheet = workbook.Worksheets[0];

        // Instantiate FindOptions Object
        FindOptions findOptions = new FindOptions();
        findOptions.LookInType = LookInType.Formulas;

        // Finding the cell containing the specified formula
        Cell cell = worksheet.Cells.Find("=SUM(A5:A10)", null, findOptions);

        // Printing the name of the cell found after searching worksheet
        System.Console.WriteLine("Name of the cell containing formula: " + cell.Name);
        ```
    3. Finding Data or Formulas using Find Options
        ```csharp
        // For complete examples and data files, please go to https://github.com/aspose-cells/Aspose.Cells-for-.NET
        // Instantiate the workbook object
        Workbook workbook = new Workbook(sourceDir + "sampleFindingDataOrFormulasUsingFindOptions.xlsx");

        workbook.CalculateFormula();

        // Get Cells collection
        Cells cells = workbook.Worksheets[0].Cells;

        // Instantiate FindOptions Object
        FindOptions findOptions = new FindOptions();

        // Create a Cells Area
        CellArea ca = new CellArea();
        ca.StartRow = 8;
        ca.StartColumn = 2;
        ca.EndRow = 17;
        ca.EndColumn = 13;

        // Set cells area for find options
        findOptions.SetRange(ca);

        // Set searching properties
        findOptions.SearchBackward = false;
        findOptions.SeachOrderByRows = true;

        // Set the lookintype, you may specify, values, formulas, comments etc.
        findOptions.LookInType = LookInType.Values;

        // Set the lookattype, you may specify Match entire content, endswith, starwith etc.
        findOptions.LookAtType = LookAtType.EntireContent;

        // Find the cell with value
        Cell cell = cells.Find(341, null, findOptions);

        if (cell != null)
        {
            Console.WriteLine("Name of the cell containing the value: " + cell.Name);
        }
        else
        {
            Console.WriteLine("Record not found ");
        }
        ```
