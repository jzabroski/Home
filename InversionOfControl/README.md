https://www.javacodegeeks.com/2012/06/spring-vs-guice-one-critical-difference.html

https://www.donaldmcintosh.net/blog/guice-better-spring

https://softwareengineering.stackexchange.com/questions/385954/do-language-features-affect-the-use-of-dependency-injection/385972#385972

https://stackoverflow.com/questions/22560043/autofac-how-to-inject-a-open-generic-delegate-in-constructor

https://stackoverflow.com/questions/39029344/factory-pattern-with-open-generics/42650112#42650112

.NET does not support open instance delegate to generic interface method:
```csharp
interface IFoo
{
	void Bar<T>(T j);
}
class Foo : IFoo
{
	public void Bar<T>(T j)
	{
	}
}
static void Main(string[] args)
{
	var bar = typeof(IFoo).GetMethod("Bar")
						  .MakeGenericMethod(typeof(int));
	var x = Delegate.CreateDelegate(typeof(Action<IFoo, int>),
									null, bar);
}
```

https://montemagno.com/add-asp-net-cores-dependency-injection-into-xamarin-apps-with-hostbuilder/ - is this useful?

https://gist.github.com/maxfridbe/3997274
