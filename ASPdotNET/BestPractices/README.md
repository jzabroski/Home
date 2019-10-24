# Long Running Requests
1. :x: http://www.beansoftware.com/ASP.NET-Tutorials/Multithreading-Thread-Pool.aspx
    - This article recommends using `ThreadPool.QueueUserWorkItem`, but the problem with this approach is that 
  2. :heavy_check_mark: [What not to do in ASP.NET, and what to do instead](https://web.archive.org/web/20131031203906/http:%2F%2Fwww.asp.net/aspnet/overview/web-development-best-practices/what-not-to-do-in-aspnet%82-and-what-to-do-instead)<br/>
    - Based on Damian Edwards' NDC talk on ASP.NET Best Practices, circa 2012
    - Quote:<br/>
      > ### [Asynchronous Page Events with Web Forms](https://web.archive.org/web/20131031203906/http:%2F%2Fwww.asp.net/aspnet/overview/web-development-best-practices/what-not-to-do-in-aspnet%82-and-what-to-do-instead#asyncevents)
      > Recommendation: In Web Forms, avoid writing async void methods for `Page` lifecycle events, and instead use `Page.RegisterAsyncTask` for asynchronous code.
      > 
      > [...]
      > 
      > ### [Fire-and-forget Work](https://web.archive.org/web/20131031203906/http:%2F%2Fwww.asp.net/aspnet/overview/web-development-best-practices/what-not-to-do-in-aspnet,-and-what-to-do-instead#fire)
      > Recommendation: When handling a request within ASP.NET, avoid launching fire-and-forget work (such calling the
      > `ThreadPool.QueueUserWorkItem` method or creating a timer that repeatedly calls a delegate).
      > 
      > If your application has fire-and-forget work that runs within ASP.NET, your application can get out of sync.
      > At any time, the app domain can be destroyed which means your ongoing process may no longer match the current state of the application.
      >
      > [...]
      > If you must perform this work within ASP.NET, you can add the Nuget package called
      > [WebBackgrounder](https://web.archive.org/web/20131031203906/http:%2F%2Fwww.nuget.org/packages/webbackgrounder) to run the code.
      >
      > ### [Long-running Requests (>110 seconds)](https://web.archive.org/web/20131031203906/http:%2F%2Fwww.asp.net/aspnet/overview/web-development-best-practices/what-not-to-do-in-aspnet,-and-what-to-do-instead#long)
      > 
      > Recommendation: Use WebSockets or SignalR for connected clients, and use asynchronous I/O operations.
      >
      > Long-running requests can cause unpredictable results and poor performance in your web application.
      > The default timeout setting for a request is 110 seconds. If you are using session state with a long-running
      > request, ASP.NET will release the lock on the Session object after 110 seconds. However, your application might be
      > in the middle of an operation on the Session object when the lock is released, and the operation might not complete
      > successfully. If a second request from the user was blocked while the first request was running, the second request
      > might access the Session object in an inconsistent state.
3. https://codewala.net/2014/03/28/writing-asynchronous-web-pages-with-asp-net-part-3/
    - Discusses using `Page.RegisterAsyncTask`
    - Quote<br/>
      > In page life cycle, when `Page_load` gets fired, ASP.NET finds it async and when it reaches to await,
      > it releases the current thread and a new thread is picked from the thread pool to continue the activity
      > and the call the web service took place asynchronously. Once the data returns from service, the same UI
      > thread is assigned to execute further. But there is better way to use async and await in web page.
