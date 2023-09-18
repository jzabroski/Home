1. https://nordicapis.com/optimize-developer-experience-api/
2. https://web.archive.org/web/20081029001109/http://www.pluralsight.com/community/blogs/tewald/archive/2006/04/19/22111.aspx
    > He's right, the model I describe does not deal with removal of elements. I divide the versioning problem into three types of changes:
    > 
    > 1. Adding new constructs (types, elements, portTypes, etc.)
    > 2. Extending existing constructs
    > 3. Changing existing constructs
    > 
    > You can do (1) without concern. You can do (2) using the model I described. For (3), you typically need to define a new set of types in a new namespace (there might be some serializer-level trickery to avoid this, but this is the general rule). I'm okay with this breakdown for two reasons. First, I think that 1 and 2 are far more common. Second, I have a way to handle 3 using a new targetNamespace but multiplexing both the old and the new namespace to a single object model. That would deal with the removal problem. I'll post code to do that too.
    > 
    > here is another way around this problem too. Raimond asked about the removal of “allowed” elements, not “required” elements. I'm a big fan of making all elements optional, with the common exception of a required identity element. In other words, if you're designing a schema for use by multiple services and you don't know which services will be able to provide which pieces of data, you're better of designing a very loose schema that focuses on describing the shape of the data if it's present.
    > 
    > In other words, you could move from this V1 definition:
    > 
    > ```xml
    > <complexType name=”CustomerType”>
    >   <sequence>
    >     <element name=”Name” type=”string” minOccurs=”0” />
    >   </sequence>
    > </complexType>
    > ```
    > 
    > to this V2 definition:
    > 
    > ```xml 
    > <complexType name=”CustomerType”>
    >   <sequence>
    >     <element name=”Name” type=”string” minOccurs=”0” />
    >     <element name=”FirstName” type=”string” minOccurs=”0” />
    >     <element name=”LastName” type=”string” minOccurs=”0” />
    >   </sequence>
    > </complexType>
