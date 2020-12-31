# For creating multi-platform images
1 - Build and push the two images to docker hub. One using windows containers, other using linux containers:
https://github.com/dgvives/base-mysql-windows-docker

```
docker image build . -t davidgarciavivesdn/base-mysql:windows
docker push davidgarciavivesdn/base-mysql:windows
```

https://github.com/dgvives/base-mysql-linux-docker

```
docker image build . -t davidgarciavivesdn/base-mysql:linux
docker push davidgarciavivesdn/base-mysql:linux
```

2 - Create a manifest and push to dockerhub

```
docker manifest create davidgarciavivesdn/base-mysql davidgarciavivesdn/base-mysql:linux davidgarciavivesdn/base-mysql:windows

docker manifest push davidgarciavivesdn/base-mysql:latest
```

3 - Reference image as `davidgarciavivesdn/base-mysql` and it should pull the proper one based on docker client requesting them. I used this as a sample:
https://github.com/Deffiss/testenvironment-docker/blob/master/samples/test-bll-with-nunit/BLLlWithNunitSample/BLLTests/TestBase.cs

```
private DockerEnvironment PrepareDockerEnvironment(DockerEnvironmentBuilder environmentBuilder)
        {
            return environmentBuilder
                     .UseDefaultNetwork()
                     .AddMariaDBContainer(
                                name: "dummyContainer",
                                rootPassword: "someDummyPassword",
                                imageName: "davidgarciavivesdn/base-mysql"
            ).Build();
        }
```


# For running GUI apps on Linux

```dockerfile
# Create the GUI User
###############################################################################
ENV USERNAME guiuser
RUN useradd -m $USERNAME && \
    echo "$USERNAME:$USERNAME" | chpasswd && \
    usermod --shell /bin/bash $USERNAME && \
    usermod -aG sudo $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME && \
    # Replace 1000 with your user/group id
    usermod  --uid 1000 $USERNAME && \
    groupmod --gid 1000 $USERNAME
# To run a GUI application, you need to do it from this user! From root type `su guiuser`.
```
