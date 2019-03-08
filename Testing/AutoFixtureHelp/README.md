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

[Categorized list of AutoFixture questions](http://nikosbaxevanis.com/blog/2013/06/09/categorized-list-of-autofixture-questions/)
