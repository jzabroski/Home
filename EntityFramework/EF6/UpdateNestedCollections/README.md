https://entityframework.net/knowledge-base/41482484/ef---automapper--update-nested-collections

NOTE: As of AutoMapper 9.0, there is no static AutoMapper.Map function.  An alternative approach is to setup an `IMappingAction` and pass that to `AfterMap`.

NOTE: This is a bit messy - why do we need a MappingAction instead of a TypeConvert?  TODO - investigate using TypeConverter approach instead.


```c#
public static class Extensions
{
    public static IMappingExpression<TSource, TDestination> IgnoreMember<TSource, TDestination, TMember>(
            this IMappingExpression<TSource, TDestination> expression, Expression<Func<TDestination, TMember>> destinationMember)
    {
            return expression.ForMember(destinationMember, o => o.Ignore());
    }
}

// AutoMapper Profile
public class MyProfile : Profile
{

    protected override void Configure()
    {

        Mapper.CreateMap<CountryData, Country>()
            .IgnoreMember(d => d.Cities)
            .AfterMap<AddDeleteOrUpdateCitiesMappingAction>();
    }
}

public class AddDeleteOrUpdateCitiesMappingAction : IMappingAction<CountryData, Country>
{
    public void Process(CountryData source, Country destination, ResolutionContext context)
    {
        if (source == null) throw new ArgumentNullException(nameof(source));
        if (destination == null) throw new ArgumentNullException(nameof(country));
        
        // Handle add or update scenarios
        foreach (var sourceItem in source.Cities)
        {
            // if the value is transient, map it.
            if (source.Id == default)
            {
                destination.Cities.Add(Mapper.Map<City>(sourceItem));
            }
            else
            {
                context.Mapper.Map(source, destination.Cities.SingleOrDefault(c => c.Id == sourceItem.Id));
            }
        }
        
        // Handle delete scenarios
        var sourceIds = source.Cities.Select(x => x.Id).ToList();
        var destinationIds = destination.Cities.Select(x => x.Id).ToList();
        var idsToRemove = destinationIds.Except(sourceIds).ToList();
        
        destination.Cities.RemoveAll(x => idsToRemove.Contains(x.Id));
    }
}
```
