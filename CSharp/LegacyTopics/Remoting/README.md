# Using an empty Ping RPC call
[StackOverflow: How to test a remoting connection (check state)](https://stackoverflow.com/a/287567/1040437)

> Is there a way to check to see if a remoting connection is still alive?  Is there a property I can check to determine the state of the remoting connection?

> 1. Add an extra method to the remoting server MarshallByRef class that does nothing and returns nothing.
> I generally name it `Ping()`, as in:
> ```c#
> public void Ping() {} 
> ```
> 2. Then, to "test" the connection, call `Ping()`... If it throws a `System.Net.Sockets.Exception`, the connection failed.

# Using Mountebank
[Testing Microservices with Mountebank Chapter 8. Protocols - Testing Microservices with Mountebank 8.5.1. Creating a simple .NET Remoting client](https://livebook.manning.com/book/testing-microservices-with-mountebank/chapter-8/105)

> You could write the test two ways, assuming you aim to virtualize the remote service.
> 
> The first way is to create a mountebank stub that proxies the remote service and captures the response. You could replay the response in your test.
> 
> The second way is much cooler. You could create the response (as in an instance of the AnnouncementLog class) in the test itself, as you would with traditional mocking tools, and have mountebank return it when the client calls the Announce method. Much cooler.
> 
> Fortunately, Matthew Herman has written an easy to use mountebank library for C# called [`MbDotNet`](https://github.com/mattherman/MbDotNet).[5] Let’s use it to create a test fixture. I like to write tests using the Law of Wishful Thinking, by which I mean I write the code I want to see and figure out how to implement it later. This allows my test code to clearly specify the intent without getting lost in the details. In this case, I want to create the object graph that mountebank will return inside the test itself and pass it off to a function that creates the imposter on port 3000 using a `contains` predicate for the remote method name. That’s a lot to hope for, but I’ve wrapped it up in a function called `CreateImposter`, as shown in the following listing.
> 
> ```csharp
> [TestFixture]
> public class TownCrierGatewayTest
> {
>     private readonly MountebankClient mb =
>         new MountebankClient();
> 
>     [TearDown]
>     public void TearDown()
>     {
>         mb.DeleteAllImposters();
>     }
> 
>     [Test]
>     public void ClientShouldAddSuccessMessage()
>     {
>         var stubResult = new AnnouncementLog("TEST");
>         CreateImposter(3000, "Announce", stubResult);
>         var gateway = new TownCrierGateway(3000);
> 
>         var result = gateway.AnnounceToServer(
>             "ignore", "ignore");
> 
>         Assert.That(result, Is.EqualTo(
>             $"Call Success!\n{stubResult}"));
>     }
> }
> ```
>
> <sup>5</sup> An entire ecosystem of these client bindings exists for mountebank. I do my best to maintain a list at http://www.mbtest.org/docs/clientLibraries, but you can always search GitHub for others. Feel free to add a pull request to add your own library to the mountebank website.
>
> This fixture uses NUnit annotations[6] to define a test. NUnit ensures that the `TearDown` method will be called after every test, which allows you to elegantly clean up after yourself. When you create your test fixture, you create an instance of the mountebank client (which assumes `mb` is already running on port 2525) and remove all imposters after every test. This is the typical pattern when you use mountebank’s API for functional testing.
> 
> The test itself uses the standard Arrange-Act-Assert pattern of writing tests introduced back in chapter 1. Conceptually, the Arrange stage sets up the system under test, creating the `TownCrierGateway` and ensuring that when it connects to a virtual service (on port 3000), the virtual service responds with the wire format for the object graph represented by `stubResult`. The Act stage calls the system under test, and the Assert stage verifies the results. This is nearly identical to what you would do with traditional mocking tools.
> 
> Wishful thinking only gets you so far. MbDotNet simplifies the process of wiring up your imposter using C#. You’ll delay only the serialization format for the response under a wishfully-thought-of method I have named `Serialize`:
>
> ```c#
> private void CreateImposter(int port,
>     string methodName, AnnouncementLog result)
> {
>     var imposter = mb.CreateTcpImposter(
>         port, "TownCrierService", TcpMode.Binary);
>     imposter.AddStub()
>         .On(ContainsMethodName(methodName))
>         .ReturnsData(Serialize(result));
>     mb.Submit(imposter);
> }
> 
> private ContainsPredicate<TcpPredicateFields> ContainsMethodName(
>     string methodName)
> {
>     var predicateFields = new TcpPredicateFields
>     {
>         Data = ToBase64(methodName)
>     };
>     return new ContainsPredicate<TcpPredicateFields>(
>         predicateFields);
> }
> 
> private string ToBase64(string plaintext)
> {
>     return Convert.ToBase64String(
>         Encoding.UTF8.GetBytes(plaintext));
> }
> ```
> 
> The `CreateImposter` and `ContainsMethodName` methods uses the MbDotNet API, which is a simple wrapper around the mountebank REST API. The REST call is made when you call mb.Submit. The ToBase64 method uses the standard .NET library calls to encode a string in Base64 format.
> 
> All that’s left is to fill in the Serialize method. This is the method that has to accept the object graph you want your virtual service to return and transform it into the stream of bytes that looks like a .NET Remoting response. That means understanding the wire format of .NET Remoting.
> 
> That’s hard.
> 
> The good news is that, with many popular RPC protocols, someone else has usually done the hard work for you. For .NET Remoting, that someone else is Xu Huang, who has created .NET Remoting parsers for .NET, Java, and JavaScript.[7] You’ll use the .NET implementation to create the Serialize function.
> 
> <sup>7</sup> See https://github.com/wsky/RemotingProtocolParser.
> 
> TODO https://livebook.manning.com/book/testing-microservices-with-mountebank/chapter-8/118
> 
> ```c#
> public string Serialize(Object obj)
> {
>     var messageRequest = new MethodCall(new[] {
>         new Header(MessageHeader.Uri,
>             "tcp://localhost:3000/TownCrier"),
>         new Header(MessageHeader.MethodName,
>             "Announce"),
>         new Header(MessageHeader.MethodSignature,
>             SignatureFor("Announce")),
>         new Header(MessageHeader.TypeName,
>             typeof(Crier).AssemblyQualifiedName),
>         new Header(MessageHeader.Args,
>             ArgsFor("Announce"))
>     });
>     var responseMessage = new MethodResponse(new[]      c
>     {
>         new Header(MessageHeader.Return, obj)
>     }, messageRequest);
> 
>     var responseStream = BinaryFormatterHelper.SerializeObject(
>         responseMessage);
>     using (var stream = new MemoryStream())
>     {
>         var handle = new TcpProtocolHandle(stream);
>         handle.WritePreamble();
>         handle.WriteMajorVersion();
>         handle.WriteMinorVersion();
>         handle.WriteOperation(TcpOperations.Reply);
>         handle.WriteContentDelimiter(
>             TcpContentDelimiter.ContentLength);
>         handle.WriteContentLength(
>             responseStream.Length);
>         handle.WriteTransportHeaders(null);
>         handle.WriteContent(responseStream);
>         return Convert.ToBase64String(
>             stream.ToArray());
>     }
> }
> 
> private Type[] SignatureFor(string methodName)
> {
>     return typeof(Crier)
>         .GetMethod(methodName)
>         .GetParameters()
>         .Select(p => p.ParameterType)
>         .ToArray();
> }
> 
> private Object[] ArgsFor(string methodName)
> {
>     var length = SignatureFor(methodName).Length;
>     return Enumerable.Repeat(new Object(), length).ToArray();
> }
> ```
