In ASP.NET Core MVC, the request object is not buffered, and so [FromBody] can only be bound to one parameter. In addition, by default, [FromBody] is applied when the request header's content-type is `application/x-www-form-urlencoded`.

This leads to some odd limitations, such as needing distinct method names for the same action, depending upon :

```c#
    public class JsonRequestItem {
        public string jsonRequest { get; set; }
    }

    [HttpPost]
    [ActionName("NewRequest")]
    [Consumes("application/json")]
    public IActionResult NewRequestFromBody([FromBody]JsonRequestItem item) {
        return NewRequest(item.jsonRequest);
    }

    [HttpPost]
    [ActionName("NewRequest")]
    [Consumes("application/x-www-form-urlencoded")]
    public IActionResult NewRequestFromForm([FromForm]JsonRequestItem item) {
        return NewRequest(item.jsonRequest);
    }

    private IActionResult NewRequest(string jsonRequest) {
        return new EmptyResult(); // example
    }
```

* There _are_ workarounds to this, such as a custom `[FromBodyOrDefault]` attribute.
* Source: https://stackoverflow.com/a/69510816/1040437

Additionally, one (not recommended) possibility is to force buffering:

```c#
// Enable request body be read mutiple times before first read(in my case,I tried with a middleware)
app.Use(async (httpcontext, next) =>
{
    httpcontext.Request.EnableBuffering();
    await next.Invoke();
});
// source: https://stackoverflow.com/a/77401870/1040437
```
