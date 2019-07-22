# Attributes are not a maintainable idea

## 
Case in point, 1: https://www.reddit.com/r/csharp/comments/cegdrc/looking_for_a_library_if_one_exists_for_this/eu3wv6j/?context=3

## If you have to use Attributes, test their presence

Case in point, 2: https://davidpine.net/blog/asp-net-core-security-unit-testing/

> We can add a few additional sanity checks along the way - with the caveat that this is not your typical “unit test”. For example we could add the following:
> 
> * Assert that we do in fact load assemblies
> * Assert that count of all the controllers is greater than the unauthorized controllers
> * Assert that we find our “white-listed” controller
