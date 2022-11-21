# FAQ

When presenting our PoC outcome to our engineers we received great questions. Here are a few of those questions with answers (to the best of our knowledge).

## JSON is elaborated natively by browsers and mobile devices. Is it the same for gRPC responses?

Although the state of gRPC in the browser has changed a lot during the last years and there are now libraries for JavaScript, gRPC is very focused on backend services and that’s where we focused our investigation on. For testing purposes you could have proxies that translate between JSON and proto. In any case, remember that gRPC primarily targets backend and edge services.

## Do you need a Circuit Breaker with gRPC?

gRPC allows you to set deadlines (and you should always do so). However, you might still need a Circuit Breaker for connection back-off if this hasn’t been implemented for your language (it’s already part of the gRPC interface).

## Do you need to set a deadline on the gRPC client when using a Circuit Breaker?

If you don’t set a deadline your Circuit Breaker (e.g. Hystrix/Resilience4J) will kill the thread but the underlying request will still be running. This means that you’ll need both a deadline and a Circuit Breaker.

## gRPC sounds perfect. What are the disadvantages of it?

As every single technology, gRPC has disadvantages as well. A non-extensive list follows:

* gRPC is not as highly adopted as REST.
* Request / response is binary and so not human readable. At application level though you can still log or debug in the same way you do with REST.
* Tooling around gRPC is still limited and except from Go where this is pretty well-established you might face challenges. In the meantime, you might find this list useful!
* There’s no 1:1 mapping between gRPC and HTTP status codes. Error messages are also not quite useful. But you can work around that by implementing interceptors or/and by using Google’s gRPC error model.
