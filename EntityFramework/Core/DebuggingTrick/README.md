```c#
using System;
using System.Diagnostics;
using Microsoft.EntityFrameworkCore;

namespace XXXX
{
	internal class DbContextDiagnosticObserver : IObserver<DiagnosticListener>
	{
		private readonly DbContextLazyLoadObserver LazyLoadObserver =
			new DbContextLazyLoadObserver();

		public void OnCompleted() { }

		public void OnError(Exception error) { }

		public void OnNext(DiagnosticListener listener)
		{
			if (listener.Name == DbLoggerCategory.Name)
				listener.Subscribe(LazyLoadObserver);
		}
	}
}
```

```c#
using System;
using System.Collections.Generic;

namespace XXXX
{
	internal class DbContextLazyLoadObserver : IObserver<KeyValuePair<string, object>>
	{
		public void OnCompleted() { }
		public void OnError(Exception error) { }

		public void OnNext(KeyValuePair<string, object> @event)
		{
			// If we see some Lazy Loading, it means the developer needs to
			// fix their code!
			if (@event.Key.Contains("LazyLoading", StringComparison.InvariantCultureIgnoreCase))
				throw new InvalidOperationException(@event.Value.ToString());
		}
	}
}
```



In your DBContext class:
```c#
#if DEBUG
		static ApplicationDbContext()
		{
			// In DEBUG mode we throw an InvalidOperationException
			// when the app tries to lazy load data.
			// In production we just let it happen, for data
			// consistency reasons.
			DiagnosticListener.AllListeners.Subscribe(new DbContextDiagnosticObserver());
		}
#endif
```
