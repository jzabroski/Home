[StackOverflow: How to test a remoting connection (check state)](https://stackoverflow.com/a/287567/1040437)

> Is there a way to check to see if a remoting connection is still alive?  Is there a property I can check to determine the state of the remoting connection?

> 1. Add an extra method to the remoting server MarshallByRef class that does nothing and returns nothing.
> I generally name it `Ping()`, as in:
> ```c#
> public void Ping() {} 
> ```
> 2. Then, to "test" the connection, call `Ping()`... If it throws a `System.Net.Sockets.Exception`, the connection failed.

