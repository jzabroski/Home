1. [Secret unit testing tools no one ever told you about](https://www.slideshare.net/dhelper/secret-unit-testing-tools-no-one-ever-told-you-about)
2. http://dontcodetired.com/blog/?tag=/bddfy

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
