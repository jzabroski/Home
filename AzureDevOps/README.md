#### [GitVersion and GitHub with Azure DevOps build yaml](https://www.neovolve.com/2019/05/03/gitversion-and-github-with-azure-devops-build-yaml/)
by Rory Primrose

Discusses:

1. How to log commands and the [AzureDevOps logging commands documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands?view=azure-devops&tabs=bash#updatebuildnumber-override-the-automatically-generated-build-number)
2. How to update the build number using GitVersion
3. How to trigger a GitHub release

#### Using PowerShell to customize build pipeline

This is a terrible hack, but worth noting:

https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/powershell?view=azure-devops

#### Reading the task.json on azure-pipeline-tasks instead of docs

For some reason, the task.json is better documentation than the official site.

Compare:

1. https://github.com/microsoft/azure-pipelines-tasks/blob/master/Tasks/NuGetCommandV2/task.json
2. https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/package/nuget?view=azure-devops
