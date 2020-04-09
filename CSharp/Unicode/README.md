http://www.aleprojects.com/en/doc/iterate-utf16

#### What's the fastest way to replace a substring of a Unicode string?

> Most "ReplaceAt" commonly methods seen online fail when replace a character at a specific position in a Unicode string.
> 
> Source: http://metadataconsulting.blogspot.com/2019/03/A-Unicode-ReplaceAt-string-extension-method-handles-Unicode-string-properly.html
https://dotnetfiddle.net/DdiKZl

#### What's the right way to get a Substring of a Unicode string?

https://stackoverflow.com/a/61125710/1040437

#### What's the right way to Split a Unicode string into equal sizes?

https://stackoverflow.com/a/8959444/1040437

```c#

using System;
using Extensions;

namespace TestCSharp
{
    class Program
    {
        static void Main(string[] args)
        {    
            string asciiStr = "This is a string.";
            string unicodeStr = "これは文字列です。";

            string[] array1 = asciiStr.Split(4);
            string[] array2 = asciiStr.Split(-4);

            string[] array3 = asciiStr.Split(7);
            string[] array4 = asciiStr.Split(-7);

            string[] array5 = unicodeStr.Split(5);
            string[] array6 = unicodeStr.Split(-5);
        }
    }
}

namespace Extensions
{
    public static class StringExtensions
    {
        /// <summary>Returns a string array that contains the substrings in this string that are seperated a given fixed length.</summary>
        /// <param name="s">This string object.</param>
        /// <param name="length">Size of each substring.
        ///     <para>CASE: length &gt; 0 , RESULT: String is split from left to right.</para>
        ///     <para>CASE: length == 0 , RESULT: String is returned as the only entry in the array.</para>
        ///     <para>CASE: length &lt; 0 , RESULT: String is split from right to left.</para>
        /// </param>
        /// <returns>String array that has been split into substrings of equal length.</returns>
        /// <example>
        ///     <code>
        ///         string s = "1234567890";
        ///         string[] a = s.Split(4); // a == { "1234", "5678", "90" }
        ///     </code>
        /// </example>            
        public static string[] Split(this string s, int length)
        {
            System.Globalization.StringInfo str = new System.Globalization.StringInfo(s);

            int lengthAbs = Math.Abs(length);

            if (str == null || str.LengthInTextElements == 0 || lengthAbs == 0 || str.LengthInTextElements <= lengthAbs)
                return new string[] { str.ToString() };

            string[] array = new string[(str.LengthInTextElements % lengthAbs == 0 ? str.LengthInTextElements / lengthAbs: (str.LengthInTextElements / lengthAbs) + 1)];

            if (length > 0)
                for (int iStr = 0, iArray = 0; iStr < str.LengthInTextElements && iArray < array.Length; iStr += lengthAbs, iArray++)
                    array[iArray] = str.SubstringByTextElements(iStr, (str.LengthInTextElements - iStr < lengthAbs ? str.LengthInTextElements - iStr : lengthAbs));
            else // if (length < 0)
                for (int iStr = str.LengthInTextElements - 1, iArray = array.Length - 1; iStr >= 0 && iArray >= 0; iStr -= lengthAbs, iArray--)
                    array[iArray] = str.SubstringByTextElements((iStr - lengthAbs < 0 ? 0 : iStr - lengthAbs + 1), (iStr - lengthAbs < 0 ? iStr + 1 : lengthAbs));

            return array;
        }
    }
}
```
