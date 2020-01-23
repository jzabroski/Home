1. [Serializing an array of multiple types](https://stackoverflow.com/questions/28462449/serializing-an-array-of-multiple-types-using-xmlserializer)
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
