1. https://docs.automapper.org/en/stable/Expression-Translation-(UseAsDataSource).html
2. https://docs.automapper.org/en/stable/Queryable-Extensions.html
3. https://docs.automapper.org/en/stable/Dependency-injection.html#autofac
4. Is AssertConfigurationIsValid good enough? https://stackoverflow.com/questions/12037986/is-automapper-assertconfigurationisvalid-enough-to-ensure-good-mapping/12038086#12038086
    1. Spoiler: No.  If your entity has a numeric property mapped to an integer, and your model is a string, it is technically incorrect. 
    2. [AutoMapper/AutoMapper#3071](https://github.com/AutoMapper/AutoMapper/issues/3071) - AssertConfigurationIsValid does not fail when mapping from nullable type to non-nullable type
           - This is closed as "by design".
