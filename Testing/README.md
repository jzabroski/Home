1. [Secret unit testing tools no one ever told you about](https://www.slideshare.net/dhelper/secret-unit-testing-tools-no-one-ever-told-you-about)
2. http://dontcodetired.com/blog/?tag=/bddfy
3. SpecsFor - https://medium.com/@ericjwhuang/consumer-driven-contract-testing-pact-d791a3eac72a
4. [Enrico Campidoglio - Testing the essential with AutoFixture](https://vimeo.com/108441213)
    > Imagine this: you’ve just been assigned maintenance of a system. You’re eager to understand what the system does so the first thing you do is to look for tests. You’re in luck, there are hundreds of them. After having opened up a few of them, you start seeing objects being constructed left and right, filled with values like 123, “Test” and “Foo”. What do all those values mean? Are they relevant for the outcome of the tests? What is really going on here?
    > 
    > In this session I’ll show you how to get rid of those questions by leveraging anonymous test data. By using a library such as AutoFixture to runtime-generate test data that meets your requirements, you can free yourself from having to write a lot of boilerplate setup code in your tests, leaving them to contain just the essence of what is being tested. It’ll also make them more robust, since they no longer rely on hard coded constants to determine their outcome.
    > 
    > Like with my other things in life, less is more. Learn how to apply this powerful principle to your tests.

# Auto-Mocking Container design pattern
The following is an example of an [Auto-Mocking Container](https://blog.ploeh.dk/2013/03/11/auto-mocking-container/)

    using AutoFixture;
    using FluentValidation.TestHelper;
    using Moq;
    using Xunit;
    using System;

    public interface IRepository<T>
    {
        T FindById(long id);
    }

    public class Customer
    {
        public long Id { get; set; }
    }

    public class CustomerValidator : AbstractValidator<Customer>
    {
        CustomerValidator(IRepository<Customer> repository)
        {
            RuleFor(c => c.Id)
                .NotEmpty();
  
            RuleFor(c => c.Id)
                .Must(c => repository.FindById(c) != null)
                .When(c => c != 0);
        }
    }
  
    public class ExampleTests
    {
        Fixture = new Fixture();
    
        [Fact]
        public void Validate()
        {
            var existingCustomer = Fixture.Create<Customer>();
            var repository = Fixture.Freeze<Mock<IRepository<Customer>>();
            repository.Setup(x => x.FindById(It.IsAny<long>())).Returns(existingCustomer);
        
            var sut = Fixture.Create<CustomerValidator>();
            // the previous line is equivalent to:
            // var sut = new CustomerValidator(repository.Object);
        
            // Act and Assert using fluent Should* extension methods:
            // - ShouldNotHaveValidationErrorFor
            // - ShouldHaveValidationErrorFor
            sut.ShouldNotHaveValidationErrorFor(x => x.Id, Fixture.Create<Customer>());
        
            // verify the mocked interactions are called
            repository.Verify();
        }
    }
