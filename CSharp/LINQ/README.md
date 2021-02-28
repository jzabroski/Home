# Nicer aggregation API?
See: https://github.com/morelinq/MoreLINQ/issues/326

# Eric Lippert on LINQ and Closures

1. [Closing over the loop variable considered harmful, part one](https://ericlippert.com/2009/11/12/closing-over-the-loop-variable-considered-harmful-part-one/)
    > UPDATE: We are taking the breaking change.
    > In C# 5, the loop variable of a foreach will be logically inside the loop,
    > and therefore closures will close over a fresh copy of the variable each time.
    > The for loop will not be changed.
    > We return you now to our original article.
    > 
    > ```c#
    > var values = new List<int>() { 100, 110, 120 }; 
    > var funcs = new List<Func<int>>(); 
    > foreach(var v in values) 
    >   funcs.Add( ()=>v ); 
    > foreach(var f in funcs) 
    >   Console.WriteLine(f());
    > ```
