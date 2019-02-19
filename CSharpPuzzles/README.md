# What does the following program print?
```csharp
List<Action> actions = new List<Action>();

for (int i = 0; i < 10; i++)
{
    actions.Add(() => Console.WriteLine(i));
}

foreach (Action action in actions)
{
    action();
}
```

# Trickiness with XmlSerializers
https://social.msdn.microsoft.com/Forums/vstudio/en-US/10e2b5ad-ab73-48a3-9519-89ba1d1d0021/are-arrays-supported-as-the-t-in-faultexceptiont-eg?forum=wcf
