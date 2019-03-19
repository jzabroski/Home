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

# .NET Core Development Tricks
1. `dotnet docker-watch` See: https://medium.com/lucjuggery/docker-in-development-with-nodemon-d500366e74df

# .NET Core Deployment Steps
1. `dotnet restore`
2. `dotnet publish`
3. `dotnet you-app.dll`

For IIS: .NET Core Windows Server Hosting Bundle to proxy requests to Kestrel

For Azure: Publish an App Service through dialog.

PowerShell Script: check if any existing docker image is running on the target port. If it is, stop it. Then we can run the image.

# Dockerfile examples

## Visual Studio Tools for Docker script
``` docker
FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 59518
EXPOSE 44364

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY HelloDockerTools/HelloDockerTools.csproj HelloDockerTools/
RUN dotnet restore HelloDockerTools/HelloDockerTools.csproj
COPY . .
WORKDIR /src/HelloDockerTools
RUN dotnet build HelloDockerTools.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish HelloDockerTools.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "HelloDockerTools.dll"]
```

## Bitbucket Pipelines script
``` docker
pipelines:
  default:
    - step:
      image: microsoft/dotnet:SDK
      services;
        - docker
      script:
        # BUILD AND COMPILE
        # build and test the dotnet app
        - dotnet restore
        - dotnet build
        
        # BUILD IMAGE
        # Define the image name so wr can store it in the Image Repository
        - export IMAGE_NAME=<my.domy.dockerhub.username>/<my.app{:$BITBUCKET_COMMIT
        # Build the Docker image (this will use the Dockerfile in the rest of the repo)
        - docker build -t $IMAGE_NAME 
        # Authenticate with the docker registry
        - docker login --username $DOCKER_HUB_USERNAME --password $DOCKER_HUB_PASSWORD
        # Push the new Docker image to the Docker registry
        - docker push $IMAGE_NAME
        
        # Deploy to Kubernetes
        - curl -L0 https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin^linux/amd64/kubectl
        - chmod +x ./kubectl
        - sudo mv ./kubectl /usr/local/bin/kubectl
        # Configure the necessary tools to deploy to Kubernetes
        - kubectl config set-cluster <my.cluster.name> --server=<my.kubernetes.host> --certificate-authority=/path/to/ca.pem
        - kubectl config set-credentials todo
        - kubectl config set-context todo
        - kubectl config set-context 
        # Update the deployment to the new docker image
        
```

## Empower developers to own not only the target environment,  but the build system, via a build container
This is a key point in YouTube talk "Build, Debug, Deploy ASP.NET Core Apps with Docker"

```powershell
Docker-compose -f .\docker.compose.ci.build.yml
```

## Docker tips
1. Deploy based on a hash, not a label.
    1. People can change a label, but not a hash.
2. Switching between Windows and Linux containers with Docker for Windows  https://www.containerstack.io/docker-on-windows-switch-to-windows-linux-mode/
    1. The easiest way is to right click on the Docker icon on the taskbar.
And click on Switch to Windows/Linux containers… dd
    2. 

Copy the debugger in your dockercompose file
Is this still needed?
```docker
FROM microsoft/aspnetcore:1.0.1
ARG source
WORKDIR /app
EXPOSE 80
COPY ${source:-bin/Release/PublishOutput} .
ENTRYPOINT ["dotnet", "Web.dll"]
```


And

```docker
#  Copy the debugger 
COPY CLRDBG


```

# Installing Docker on Windows

## Why does Docker for Windows require features required for virtualization?

The short answer is that Docker relies on numerous features, such as namespaces and cgroups, and these are not available on Windows. To get around this limitation, Docker for Windows creates a lightweight Hyper-V container running a Linux kernel. At the time of writing, Docker includes experimental support for Native containers that allow for creation of containers without the need for Hyper-V.

## Docker CE for Windows
https://hub.docker.com/editions/community/docker-ce-desktop-windows

The install may ask you to enable Hyper-V and containers. Say yes.

Once the install is complete, open a command prompt window (or PowerShell, if that is your preference) and type the command shown below to check that Docker is installed and is working correctly.

```powershell
docker run --rm hello-world
```
Should output:
```
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/ hello-world ca4f61b1923c: Pull complete
Digest: sha256: 66ef312bbac49c39a89aa9bcc3cb4f3c9e7de3788c944158df3ee0176d32b751
Status: Downloaded newer image for hello-world:latest
Hello from Docker! This message shows that your installation appears
```

If we see the message "Installation appears to be working correctly", you should be good for now.

## Docker on Ubuntu Linux

1. Update the apt index:
    `sudo apt-get update`
2. Install the necessary packages repository over HTTPS:
    ``
    sudo apt-get install \
    apt-transport-https ca-certificates \
    curl \
    software-properties-common
    ```
3. Install Docker’s official GPG key:
    `curl -fsSL https:// download.docker.com/ | sudo apt-key add - `
4. Add Docker’s stable repository:
    ```
    sudo add-apt-repository \
      " deb [arch = amd64] https:// download.docker.com/ linux/ ubuntu \
      $( lsb_release -cs) \
      stable"   
5. Update the apt package index:
    ```
    sudo apt-get update
    ```
6. Install Docker:
    ```
    sudo apt-get install docker-ce
    ```
    
### Additional Steps
Docker communicates via a UNIX socket that is owned by the root user. We can avoid having to type sudo by following these steps:

1. Create the docker group:
   `sudo groupadd docker`
2. Add your user to the docker group:
    `sudo usermod -aG docker $ USER. `
3. Log out and log back in. Run the command below to confirm the Docker has been installed correctly.
    `docker run --rm hello-world`


# Integrated Development Environment

## Docker for Windows and Docker Tools for Visual Studio
1. Docker for Windows
    1. https://docs.docker.com/v17.09/docker-for-windows/
2. Visual Studio Tools for Docker
    1. https://docs.microsoft.com/en-us/dotnet/standard/containerized-lifecycle-architecture/design-develop-containerized-apps/visual-studio-tools-for-docker
        1. Visual Studio Project Templates will have a dialog checkbox called "Enable Docker Container Support"
        2. How do you debug multiple docker instances running in the same Visual Studio debugging session?
            1. Possible! And edit-and-continue works. So does setting breakpoints across containers
    2. [Quickstart: Visual Studio Tools for Docker](https://docs.microsoft.com/en-us/visualstudio/containers/docker-tools?view=vs-2017)
3. [Visual Studio Tools for Docker with ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/docker/visual-studio-tools-for-docker?view=aspnetcore-2.2#docker-compose)



## Visual Studio dcproj (docker container project)
See: https://github.com/IvanZheng/IFramework/tree/master/Src for an excellent example

See also: [MSDN dotnet standard: microservices architecture: Development workflow for Docker apps](https://docs.microsoft.com/en-us/dotnet/standard/microservices-architecture/docker-application-development-process/docker-app-development-workflow)

## Public API Documentation
Want to review your API documentation in a container?

[Doctainers](https://github.com/dend/doctainers) let's you do that.

## Run your Acceptance Tests in a Docker Selenium container
[Docker-Selenium](https://github.com/SeleniumHQ/docker-selenium)

# Docker Vocabulary

## Layers
A layer is a modification applied to a Docker image as represented by an instruction in a Dockerfile.

When Docker builds the image, each layer is stacked on the next and merged into a single layer using the union filesystem. Layers are uniquely identified using sha256 hashes. This makes it easy to reuse and cache them. When Docker scans a base image, it scans for the IDs of all the layers that constitute the image and begins to download the layers. If a layer exists in the local cache, it skips downloading the cached image.

## Docker Image

Docker image is a read-only template that forms the foundation of your application. It is very much similar to, say, a shell script that prepares a system with the desired state.

## Dockerfile
Docker images are created using a series of commands, known as instructions, in the Dockerfile. The presence of a Dockerfile in the root of a project repository is a good indicator that the program is container-friendly.

## Docker Volume
An important aspect to grasp is that when a container is running, the changes are applied to the container layer and when the container is stopped/ killed, the container layer is not saved. Hence, all changes are lost. This aspect of containers is not understood very well and for this reason, stateful applications and those requiring persistent data were initially not recommended as containerized applications. However, with Docker Volumes, there are ways to get around this limitation.

## Docker Registry
Docker Registry is a place where you can store Docker images so that they can be used as the basis for an application stack. Some common examples of Docker registries include the following:
* Docker Hub
* Google Container Registry 
* Amazon Elastic Container Registry 
* JFrog Artifactory

## Dockerfile
A Dockerfile is a set of instructions that tells Docker how to build an image. A typical Dockerfile is made up of the following:
* A `FROM` instruction that tells Docker what the base image is
* An `ENV` instruction to pass an environment variable
* A `RUN` instruction to run some shell commands (for example, install-dependent programs not available in the base image)
* A `CMD` or an `ENTRYPOINT` instruction that tells Docker which executable to run when a container is started

## Docker Engine



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
