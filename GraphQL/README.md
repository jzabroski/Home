[GraphQL Kinda Sucks](https://news.ycombinator.com/item?id=32366759)

https://nhost.io/product/graphql

> * Instant and scalable GraphQL API with realtime subscriptions and powerful permissions built in.
> * Powerful and simple permissions
>   * Row and column level permissions to safely expose your GraphQL API to the world
> * Realtime Subscriptions
>   * Build collaborative apps with ease.
> * Data federation
>   * Nhost federates data from multiple sources into a single GraphQL API for any client to consume.

# Authentication
According to Apollo Authentication Over WebsSocket spec (i.e. https://www.apollographql.com/docs/graphql-subscriptions/authentication) the authentication credentials shall be passed in the connection_init message payload as authToken.

However, not every library provides a smooth way to support this.  HotChocolate's StrawberryShake library provides an ISocketConnectionInterceptor that has a callback function you can implement to enrich the connection init message payload with an authToken.

# [A dream of scalable and enriched GraphQL subscriptions](https://medium.com/pipedrive-engineering/a-dream-of-scalable-and-enriched-graphql-subscriptions-724284448e65)

* PipeDrive operates a site that utilizes streaming, real-time data to update a front-end UI.
* Sometimes, customers load 80,000 records into the backend through an xlsx file, which triggers a large amount of data pushes to the front-end UI.
* "For one customer, the volume of internet traffic reached 80 GB per day."
* Prototyped GraphQL, starting with reproducing the details shared in the YouTube tech talk [Going infinite, handling 1 millions websockets connections in Go / Eran Yanay](https://youtu.be/LI1YTFMi8W4)
  * Here’s what happened:
    * We were faced with the dilemma of the GraphQL integer spec not matching go’s int32
    * We got the per-property filtering and per-argument filtering working
    * We hit the need of SSL for WSS to work. Otherwise, CORS blocked requests
    * We got nginx to proxy web socket requests!
    * We found that there are two transport protocols. Websocket is a loose transport, so any library can implement whatever it wants. [Gophers](https://github.com/graph-gophers/graphql-transport-ws) implemented an older version that was compliant with Apollo and GraphQL but not with graphql-ws.
    * We had the issue that the Apollo federation lib did not like the Subscription in [schema registration](https://github.com/pipedrive/graphql-schema-registry).
