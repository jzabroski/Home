What does the following program print?
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
