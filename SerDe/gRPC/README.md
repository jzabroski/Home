# Testing gRPC and GPB

https://github.com/jzabroski/gmessaging forked from https://github.com/nleiva/gmessaging

# Practical API Design at Netflix, Part 1: Using Protobuf FieldMask
[Practical API Design at Netflix, Part 1: Using Protobuf FieldMask](https://netflixtechblog.com/practical-api-design-at-netflix-part-1-using-protobuf-fieldmask-35cfdc606518)

* How can we understand which fields the caller doesn’t need to be supplied in the response, so we can avoid making unnecessary computations and remove calls?
    * **GraphQL**: field selectors
    * **JSON:API**: [Sparse FieldSets](https://jsonapi.org/format/#fetching-sparse-fieldsets)
    * **Protobuf**: `FieldMask`
 
* What is FieldMask?
    > FieldMask is a protobuf message. There are a number of utilities and conventions on how to use this message when it is present in an RPC request. A FieldMask message contains a single field named paths, which is used to specify fields that should be returned by a read operation or modified by an update operation.
    > 
    > ```proto
    > message FieldMask {
    >     // The set of field mask paths.
    >     repeated string paths = 1;
    > }
    > ```

* How to use FieldMask in a Request?
    ```proto
    import "google/protobuf/field_mask.proto";
    
    message GetProductionRequest {
      string production_id = 1;
      google.protobuf.FieldMask field_mask = 2;
    }
    ```

* How to retain performance benefits of using Protobuf serialization?
    * Protobuf Field Names vs Field Numbers
        > You might notice that paths in the `FieldMask` are specified using field names, whereas on the wire, encoded protocol buffers messages contain only field numbers, not field names. This (alongside some other techniques like [ZigZag encoding](https://en.wikipedia.org/wiki/Variable-length_quantity#Zigzag_encoding) for signed types) makes protobuf messages space-efficient.
        >
        > Here at Netflix we are using field numbers and convert them to field names using [`FieldMaskUtil.fromFieldNumbers()`](https://developers.google.com/protocol-buffers/docs/reference/java/com/google/protobuf/util/FieldMaskUtil.html#fromFieldNumbers-java.lang.Class-int...-) utility method.
        
* Dealing with Renames to Fields when using `FieldMask` approach
    * There are multiple ways to deal with this limitation:
      * Never rename fields when FieldMask is used. This is the simplest solution, but it’s not always possible
      * Require the backend to support all the old field names. This solves the backward compatibility issue but requires extra code on the backend to keep track of all historical field names
      * Deprecate old and create a new field instead of renaming. In our example, we would create the title_name field number 6. This option has some advantages over the previous one: it allows the producer to keep using generated descriptors instead of custom converters; also, deprecating a field makes it more prominent on the consumer side

* Using `FieldMask` on the Producer (Server) Side
    > On the producer (server) side, unnecessary fields can be removed from the response payload using the FieldMaskUtil.merge() method (lines ##8 and 9):
    >
    > ```java
    > @Override
    > public void getProduction(GetProductionRequest request, 
    >                           StreamObserver<GetProductionResponse> response) {
    > 
    > Production production = fetchProduction(request.getProductionId());
    > FieldMask fieldMask = request.getFieldMask();
    > 
    > Production.Builder productionWithMaskedFields = Production.newBuilder();
    > FieldMaskUtil.merge(fieldMask, production, productionWithMaskedFields);
    > ```

(!) Not finished taking notes.

# gRPC Hidden Features

https://groups.google.com/g/protobuf/c/oKLb32LLIiM

> Protobuf supports creating message types dynamically at runtime and use them for parsing/serialization/etc.
> 
> First you need to build up a DescriptorPool that contains all types that you may want to use. There are two approaches to construct this pool. One is to call DescriptorPool::BuildFile() directly with parsed proto files. For example:
> ```c++
>   // Convert .proto files into parsed FileDescriptorProto
>   bool ParseProtoFile(string filename, FileDescriptorProto* result) {
>     FileInputStream stream(filename);
>     google::protobuf::io::Tokenizer tokenizer(&stream);
>     google::protobuf::compiler::Parser parser;
>     return parser.Parse(&tokenizer, result);
>   }
>   // Build the descriptor pool
>   DescriptorPool pool;
>   for (string filename : proto_files) {
>     FileDescriptorProto proto;
>     ParseProtoFile(filename, &proto);
>     pool.BuildFile(proto);
>   }
> ```
> 
> After you have the pool, you can query for a type by its name. For example, DescriptorPool::FindMessageTypeByName().
> 
> Then to actually parse/serialize/use message types in the pool, you need to construct message objects around them. `DynamicMessage` is used for that:
> ```c++
>   // Suppose you want to parse a message type with a specific type name.
>   Descriptor* descriptor = pool.FindMessageTypeByName(message_type_to_parse);
>   DynamicMessageFactory factory;
>   unique_ptr<Message> message = factory.GetPrototype(descriptor)->New();
>   // Use the message object for parsing/etc.
>   message->ParseFromString(input_data);
>   // Access a specific field in the message
>   FieldDescriptor* field = descriptor->FindFieldByName(field_to_read);
>   switch (field->type()) {
>     case TYPE_INT32: message->GetReflection()->GetInt32(*message, field); break;
>     ...
>   }
> ```

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
* Tooling around gRPC is still limited and except from Go where this is pretty well-established you might face challenges. In the meantime, you might find [this](https://github.com/grpc-ecosystem/awesome-grpc) list useful!
* There’s no 1:1 mapping between gRPC and HTTP status codes. Error messages are also not quite useful. But you can work around that by implementing interceptors or/and by using Google’s [gRPC error model](https://grpc.io/docs/guides/error/).
