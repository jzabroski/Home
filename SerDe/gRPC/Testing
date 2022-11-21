# Testing gRPC using Bloomrpc

We can use BloomRPC as an alternative to test gRPC services. BloomRPC is a GUI tool, to test gRPC services likewise Postman for REST.

# Other means of interacting with gRPC servers

## Command-line tools for interacting with gRPC servers
Although you cannot use the usual command line tools like cURL to interact with a gRPC Server there are plenty of options that aim to be used for that purpose.

The first option is the official tool that comes with the gRPC repository, the gRPC command line tool (grpc_cli).

A popular alternative is grpcurl with its main benefit being that it’s easier to create a Docker image for (unless you have brew installed, grpc_cli requires building from the repo) and that it’s easier to make it work over TLS.

> Since in Kubernetes you can have multiple pods running your app, we found it useful to create a Docker image that has grpcurl installed and add this as a sidecar to our apps, when debugging Ingress issues. This way we managed to get an interactive shell with grpcurl in the same pod our app was running.

