# What is Docker?
Metaphor: A docker was a laborer who moved commercial goods into and out of ships when they docked at seaports.
There were boxes and items of differing sizes and shapes, 
and experienced dockers were prized for their ability to fit goods into ships by hand in cost-effective ways.

Hiring people to move stuff around wasn't cheap, but there was no alternative.

# Docker Use Cases

## Replacing Virtual Machines
If you only care about the application, not the operating system.

## Prototyping Software
Create a sandbox environment in milliseconds.

## Packaging Software
True "write once, run anywhere".

## Enabling a Microservices Architecture
Use Docker layers to compose independent parts of your application.  This verifies they are standalone microservices. You also benefit by avoiding longer services start-up times, since you've amortized the cost of start-up to just the services you need for development.

## Modeling Networks
Docker supports thousands of containers on one machine, so testing scenarios like distributed pub-sub with thousands of writers and readers becomes possible without needing lots of hardware.

## Enabling Full-Stack Productivity When Offline
Your SQL database, web layer, and client can all live on the same machine in separate containers. Take your laptop and go code.

## Reducing Debugging Overhead
Docker allows you to clearly state (in script form) the steps for debugging a problem on a system with known properties, making bug and environment reproduction much simpler.  Previously, you might submit a bug report to GitHub with sample code and information about your OS, but the project maintainer might not be able to reproduce it, because the enviroment configuration is not identical between you and the maintainer.  Containers allow you to break down these communication walls.

# Docker commands

| Command | Purpose |
| ------- | ------- |
| docker build | Build a docker image |
| docker run | Run a docker image as a container |
| docker commit | Commit a docker container as an image |
| docker tag | Tag a docker image |

# Examples
https://github.com/rafaelfgx/DotNetCoreArchitecture

