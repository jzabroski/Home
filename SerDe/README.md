
# Relevant Reading Materials

1. [Under the Hood: Building and open-sourcing fbthrift](https://engineering.fb.com/2014/02/20/open-source/under-the-hood-building-and-open-sourcing-fbthrift/) by Dave Watson, Facebook Engineering. POSTED ON FEBRUARY 20, 2014.
2. [Benchmarking - REST vs. gRPC](https://medium.com/sahibinden-technology/benchmarking-rest-vs-grpc-5d4b34360911)
3. [A Thorough Guide to Bond for C#](https://microsoft.github.io/bond/manual/bond_cs.html#deserializer)
4. [API Versioning at Stripe](https://stripe.com/blog/api-versioning) 

# Google Protobuf vs. Microsoft Bond

Google Protobuf does not support generics or inheritance.  Microsoft Bond does.

In addition, Google Protocol Buffers has a list of work-arounds for common scenarios developers face: https://developers.google.com/protocol-buffers/docs/techniques
1. Streaming Multiple Messages
   > The Protocol Buffer wire format is not self-delimiting, so protocol buffer parsers cannot determine where a message ends on their own. The easiest way to solve this problem is to write the size of each message before you write the message itself.
2. Large Data Sets
   > As a general rule of thumb, if you are dealing in messages larger than a megabyte each, it may be time to consider an alternate strategy.
3. Self-describing Messages
   > However, the contents of a .proto file can itself be represented using protocol buffers. [...] By using classes like DynamicMessage (available in C++ and Java), you can then write tools which can manipulate SelfDescribingMessages. 
   > 
   > All that said, the reason that this functionality is not included in the Protocol Buffer library is because we have never had a use for it inside Google.


# Google Protobuf vs. REST (JSON)

## JSON (9 Bytes)
```json
{
  "id":42
}
```

## Protobuf (2 Bytes)
```protobuf
0x08 0x2a
```
