https://jaliyaudagedara.blogspot.com/2015/01/using-objectstatemanager-for-object.html

# Using ObjectStateManager for Object Tracking in Entity Framework
`ObjectStateManager` in Entity Framework is responsible for tracking states and changes of an object.
In this post let’s see how we can use `ObjectStateManager` to track object changes in following scenarios.

1. Adding a new item
2. Updating simple property of an existing item
3. Updating complex property of an existing item
4. Adding item to a collection type property of an existing item
5. Removing item to a collection type property of an existing item
6. Deleting an existing item

```c#
private static void LogAddedEntries(ObjectStateEntry entry)
{
    if (entry.IsRelationship) //relationship added
    {
        StringBuilder sb = new StringBuilder();

        sb.AppendLine(string.Format("Adding relationship to : {0}", entry.EntitySet.Name));
        sb.AppendLine();
 
        var currentValues = entry.CurrentValues;

        for (var i = 0; i < currentValues.FieldCount; i++)
        {
            string fName = currentValues.DataRecordInfo.FieldMetadata[i].FieldType.Name;
            EntityKey fCurrVal = (EntityKey)currentValues[i];
 
            sb.AppendLine(string.Format("Table : {0}", fName));
            sb.AppendLine(string.Format("Property Name: {0}", fCurrVal.EntitySetName));
            sb.AppendLine(string.Format("Id : {0}", fCurrVal.EntityKeyValues[0].Value))
        }

        Console.WriteLine(sb.ToString());
        Console.WriteLine("--------------------------------------------");
    }
    else //item added
    {
        StringBuilder sb = new StringBuilder();
 
        sb.AppendLine(string.Format("Adding new item to : {0}", entry.EntitySet.Name));
        sb.AppendLine();

        var currentValues = entry.CurrentValues;
        for (var i = 0; i < currentValues.FieldCount; i++)
        {
            string fName = currentValues.DataRecordInfo.FieldMetadata[i].FieldType.Name;
            var fCurrVal = currentValues[i];

            sb.AppendLine(string.Format("Property Name : {0}", fName));
            sb.AppendLine(string.Format("Property Value : {0}", fCurrVal));
        }

        Console.WriteLine(sb.ToString());
        Console.WriteLine("--------------------------------------------");
    }
}
```

```c#
private static void LogModifiedEntries(ObjectStateEntry entry)
{
    StringBuilder sb = new StringBuilder();

    sb.AppendLine(string.Format("Modifying properties in : {0}", entry.EntitySet.Name));
    sb.AppendLine();
 
    var properties = entry.GetModifiedProperties();
 
    for (int i = 0; i < properties.Count(); i++)
    {
        string propertyName = properties.ToArray()[i];
        string OriginalValue = entry.OriginalValues.GetValue(entry.OriginalValues.GetOrdinal(propertyName)).ToString();
        string CurrentValue = entry.CurrentValues.GetValue(entry.CurrentValues.GetOrdinal(propertyName)).ToString();

        sb.AppendLine(string.Format("Property Name : {0}", propertyName));
        sb.AppendLine(string.Format("Original Value : {0}", OriginalValue));
        sb.AppendLine(string.Format("Current Value : {0}", CurrentValue));
    }

    Console.WriteLine(sb.ToString());
    Console.WriteLine("--------------------------------------------");
}
```

```c#
private static void LogDeletedEntries(ObjectStateEntry entry)
{
    if (entry.IsRelationship) //relationship deleted
    {
        StringBuilder sb = new StringBuilder();

        sb.AppendLine(string.Format("Deleting relationship from : {0}", entry.EntitySet.Name));
        sb.AppendLine();
 
        var originalValues = entry.OriginalValues;
 
        for (var i = 0; i < originalValues.FieldCount; i++)
        {
            EntityKey fCurrVal = (EntityKey)entry.OriginalValues.GetValue(i);

            sb.AppendLine(string.Format("Property Name : {0}", fCurrVal.EntitySetName));
            sb.AppendLine(string.Format("Property Value : {0}", fCurrVal.EntityKeyValues[0]));
        }

        Console.WriteLine(sb.ToString());
        Console.WriteLine("--------------------------------------------");
    }
    else //entry deleted
    {
        StringBuilder sb = new StringBuilder();

        sb.AppendLine(string.Format("Deleting item from : {0}", entry.EntitySet.Name));
        sb.AppendLine();
 
        var originalValues = entry.OriginalValues;
 
        for (var i = 0; i < originalValues.FieldCount; i++)
        {
            var fCurrVal = entry.OriginalValues.GetValue(i);
            sb.AppendLine(string.Format("Data : {0}", fCurrVal));
        }
 
        Console.WriteLine(sb.ToString());
        Console.WriteLine("--------------------------------------------");
    }
}
```
