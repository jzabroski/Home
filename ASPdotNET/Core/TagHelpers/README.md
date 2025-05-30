1. https://blog.techdominator.com/article/using-html-helper-inside-tag-helpers.html

2. Converting Razor Components into strings (for use within a tag helper)
    ```c#
    public static class HtmlContentExtensions
    {
        public static string PartialViewToString(this IHtmlContent partialView)
        {
            using (var writer = new StringWriter())
            {
                partialView.WriteTo(writer, HtmlEncoder.Default);
                return writer.ToString();
            }
        }
    }
    ```
