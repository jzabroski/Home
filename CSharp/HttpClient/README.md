1. [App-vNext/Polly#637](https://github.com/App-vNext/Polly/issues/637) - How to wire up Polly by Autofac
2. [aspnet/HttpClientFactory#148](https://github.com/aspnet/HttpClientFactory/issues/148) - `HttpClientFactory` is tightly coupled to `Microsoft.Extensions.DependencyInjection` through `DefaultHttpClientFactory` depending on `IServiceProvider`
3. [dotnet/aspnetcore#28385](https://github.com/dotnet/aspnetcore/issues/28385) - Using HttpClientFactory without dependency injection

> think of M.E.DI stuff as an implementation detail for how to get an IHttpClientFactory instance. The other features though, rely on this internal detail in order to do more complex things (like typed clients etc).
> 
> Alternatively, if you really wanted to try to integrate the 2 things (autofac and the HttpClientFactory), you can use the ServiceCollection as the configuration API for the HttpClient and use Autofac.Extensions.DependencyInjection to wire it up to your existing autofac container:
>
> ```c#
> public class MyTypedClient
> {
>     public MyTypedClient(HttpClient client)
>     {
> 
>     }
> }
> 
> public class Program
> {
>     public static void Main(string[] args)
>     {
>         var services = new ServiceCollection();
>         services.AddHttpClient()
>                 .AddHttpClient<MyTypedClient>();
> 
>         var containerBuilder = new ContainerBuilder();
>         containerBuilder.Populate(services);
>         var container = containerBuilder.Build();
>         var factory = container.Resolve<IHttpClientFactory>();
>         var typedClient = container.Resolve<MyTypedClient>();
>     }
> }


