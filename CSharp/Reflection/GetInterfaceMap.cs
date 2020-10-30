internal class Program
{
	interface IHandler<out T> where T : Exception
	{
	}

	class ArgumentHandler : IHandler<ArgumentException>
	{
	}

	static void Main(string[] args)
	{
		// Prints: Program+IHandler`1[System.Exception]
		Console.WriteLine(
			typeof(ArgumentHandler)
			.GetInterfaceMap(typeof(IHandler<Exception>))
			.InterfaceType);

		// Prints: Program+IHandler`1[System.ArgumentException]
		Console.WriteLine(
			typeof(ArgumentHandler)
			.GetAllInterfaceMaps()
			.First(im => im.InterfaceType.IsGenericType && im.InterfaceType.GetGenericTypeDefinition() == typeof(IHandler<>))
			.InterfaceType
			);
	}


}
public static class TypeExtensions
{
	public static IEnumerable<InterfaceMapping> GetAllInterfaceMaps(this Type aType) =>
	aType.GetTypeInfo()
		 .ImplementedInterfaces
		 .Select(ii => aType.GetInterfaceMap(ii));
}
