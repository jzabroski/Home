# ExcelDNA
1. http://www.clear-lines.com/blog/post/Supercharge-Excel-functions-with-ExcelDNA-and-Net-parallelism.aspx
2. Implementation of RTD Servers
    * You don't need to use Rx to make RTD servers with Excel-DNA. The Rx extensions are based on the RTD server support, but you can easily make your own RTD servers in an Excel-DNA add-in too.
    * Derive from the `ExcelRtdServer` base class (in `ExcelDna.Integration.Rtd`) to base your RTD server on.
    * Mark your class as `[ComVisible(true)]` (but **remember to never mark your assembly as "Register for COM Interop" in Visual Studio**.
    * Override at least `ConnectData` (and probably `DisconnectData`) to be notified when a new topic is connected from a worksheet function.
    * Store the `Topic` object that is passed to `ConnectData`, then call its `UpdateValue` member (as often as you want, and from any thread!) when the data should be updated.
    * Make a wrapper function that looks like this:
    ```c#
    public static object MyRTDCall(string topicInfo)
    {
        return XlCall.RTD("MyRTDServers.MyServer", null, topicInfo);
    }
    ```
    * Then call from a formula as `=MyRTDCall("XYZ")`
3. SynchronizationContext woes
    * https://groups.google.com/forum/m/#!msg/exceldna/OVwlRX09CpA/58eWs0tCAgAJ
