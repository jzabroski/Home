1. [Serializing an array of multiple types](https://stackoverflow.com/questions/28462449/serializing-an-array-of-multiple-types-using-xmlserializer) - see also [Controlling XML Serialization Using Attributes](https://docs.microsoft.com/en-us/dotnet/standard/serialization/controlling-xml-serialization-using-attributes)
    > ```xml
    > <create>
    >    <vendor> 
    >       <vendorid>Unit - A-1212</vendorid>
    >       <name>this is the name8</name>
    >       <vcf_bill_siteid3>FOOBAR8</vcf_bill_siteid3>
    >    </vendor>             
    >    <customer>
    >       <CUSTOMERID>XML121</CUSTOMERID>
    >       <NAME>XML Customer 111</NAME>
    >    </customer>             
    >    <asset>  
    >       <createdAt>San Jose</createdAt>
    >       <createdBy>Kevin</createdBy>
    >       <serial_number>123456789</serial_number>
    >    </asset> 
    > </create>
    > ```
    > 
    > ```c#
    > public class Document
    > {
    >   [XmlArray("create")]
    >   [XmlArrayItem("vendor", typeof(Vendor))]
    >   [XmlArrayItem("customer", typeof(Customer))]
    >   [XmlArrayItem("asset", typeof(Asset))]
    >   public CreateBase [] Create { get; set; }
    > }
    > ```
2. [Using Microsoft XML Serializer Generator on .NET Core](https://docs.microsoft.com/en-us/dotnet/core/additional-tools/xml-serializer-generator)
   > Like the [Xml Serializer Generator (sgen.exe)](https://docs.microsoft.com/en-us/dotnet/standard/serialization/xml-serializer-generator-tool-sgen-exe) for the .NET Framework, the [Microsoft.XmlSerializer.Generator NuGet package](https://www.nuget.org/packages/Microsoft.XmlSerializer.Generator) is the equivalent for .NET Core and .NET Standard projects. It creates an XML serialization assembly for types contained in an assembly to improve the startup performance of XML serialization when serializing or de-serializing objects of those types using XmlSerializer.
3. XmlSerializer has a constructor that will dynamically compile assemblies every time you call it.
     1. https://kalapos.net/Blog/ShowPost/how-the-evil-system-xml-serialization-xmlserializer-class-can-bring-a-server-with-32gb-ram-down
     2. [dotnet/runtime#28122 - XmlSerializer.FromTypes() memory leak](https://github.com/dotnet/runtime/issues/28122  )
