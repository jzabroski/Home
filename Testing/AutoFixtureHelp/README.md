1. When AutoFixture creates an object, it creates it with the constructor with the fewest number of paramters. Source: https://blog.ploeh.dk/2009/03/24/HowAutoFixtureCreatesObjects/
2. What about objects without any public constructors? https://blog.ploeh.dk/2009/04/23/DealingWithTypesWithoutPublicConstructors/
3. What happens if one of those constructor parameters takes a phone number, and has to be formatted (XXX) XXX-XXXX? Source: https://blog.ploeh.dk/2009/05/01/DealingWithConstrainedInput/
    ```csharp
    public DanishPhoneNumber(int number)
    {
      if ((number < 112) ||
        (number > 99999999))
      {
        throw new ArgumentOutOfRangeException("number");
      }
      this.number = number;
    }
    fixture.Register<int, DanishPhoneNumber>(i => 
      new DanishPhoneNumber(i + 112));
    ```
4. When do you need to Customize a Fixture? https://blog.ploeh.dk/2011/03/18/EncapsulatingAutoFixtureCustomizations/
    - If a class consumes interfaces a default Fixture will not be able to create it. However, this is easily fixed through one of the AutoMocking Customizations.
    - If an API has circular references, Fixture might enter an infinite recursion, but you can easily customize it to cut off one the references.
    - Some constructors may only accept arguments that don't fit with the default specimens created by Fixture. There are ways to deal with that as well.
5. OmitAutoProperties - https://blog.ploeh.dk/2009/07/23/DisablingAutoPropertiesInAutoFixture/
6. `Build<T>` circumvents Customizations defined with `Customize`
    - Q: When i use Fixture.Build to create my objects, AutoFixture ignores my customizations. Why is this?
        ```csharp
        Fixture.Customize<User>(x => x.Without(u => u.Id));
        Fixture.CreateAnonymous<User>(); // Will have empty id
        Fixture.Build<User>().CreateAnonymous(); // Will have set id
        ```
      A: This behavior is by design. The `Build<T>` method is essentially a one-off Customization, so it ignores any previous Customizations and does only exactly what you tell it.
    
[Categorized list of AutoFixture questions](http://nikosbaxevanis.com/blog/2013/06/09/categorized-list-of-autofixture-questions/)

