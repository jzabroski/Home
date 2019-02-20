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

# .NET Core Deployment Steps
1. `dotnet restore`
2. `dotnet publish`
3. `dotnet you-app.dll`

For IIS: .NET Core Windows Server Hosting Bundle to proxy requests to Kestrel
For Azure: Publish an App Service through dialog.

PowerShell Script: check if any existing docker image is running on the target port. If it is, stop it. Then we can run the image.

```powershell

```

## Docker tips
Copy the debugger in your dockercompose file
Is this still needed?
```docker
FROM microsoft

#  Copy the debugger 
COPY CLRDBG


```

# Docker for Windows and Docker Tools for Visual Studio
1. https://docs.microsoft.com/en-us/dotnet/standard/containerized-lifecycle-architecture/design-develop-containerized-apps/visual-studio-tools-for-docker
2. Docker for Windows
    1. https://docs.docker.com/v17.09/docker-for-windows/



# Examples
https://github.com/rafaelfgx/DotNetCoreArchitecture

Ideally, with SourceLink enabled: https://github.com/dotnet/sourcelink

# Tutorials
* [Deploying ASP.NET Core Applications including Octopus, Docker & RM | Danijel Malik](https://www.youtube.com/watch?v=ni2tWx8lw3M)
* [Get Started with .NET and Docker](https://www.youtube.com/watch?v=MzKDtf29bCA)
    > In this video, we briefly demo the Visual Studio features that make getting started with .NET Core and Docker easy. We also explore the benefits of being able to debug inside a container by using Visual Studio.

# Helpers
1. [dotnet-docker](https://github.com/dotnet/dotnet-docker) - The base Docker images for working with .NET Core and the .NET Core Tools.
2. [Dockerize.NET](https://github.com/brthor/Dockerize.NET) - .NET Cli Tool to package your .NET Core Application into a docker image: '`dotnet dockerize`'
3. [image2docker](https://github.com/docker/communitytools-image2docker-win) - Image2Docker is a PowerShell module which ports existing Windows application workloads to Docker. It supports multiple application types, but the initial focus is on IIS and ASP.NET apps. You can use Image2Docker to extract ASP.NET websites from a VM - or from the local machine or a remote machine. Then so you can run your existing apps in Docker containers on Windows, with no application changes.
