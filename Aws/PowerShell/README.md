# Setup

1. Install PowerShell Core (v6.1 or later)
2. Open `pwsh.exe`
3. `Install-Module AWSPowerShell.NetCore -Confirm:$false -AcceptLicense -SkipPublisherCheck`
4. `Import-Module AWSPowerShell.NetCore`
5. `Get-AWSPowerShellVersion`
6. `Get-AWSPowerShellVersion -ListServiceVersionInfo`
7. `Get-Command *s3* -Module AWSPowerShell.NetCore`
8. `Initialize-AWSDefaults`
    1. For more information on configuring AWS Defaults, please read: [Handling Credentials with AWS Tools for Windows PowerShell(https://aws.amazon.com/blogs/developer/handling-credentials-with-aws-tools-for-windows-powershell/)
    2. You will need:
        * AWS Access Key - this is available at https://console.aws.amazon.com/iam/home?region=**AwsRegion**#/users/**UserName**?section=security_credentials
        * AWS Secrete Key - this was generated when you created the **UserName**
        * Specify a default Region - this should be your primary region, e.g. us-east-1

# Common commands

## S3

`Get-S3Bucket`

## Billing

1. [`Get-CURReportDefinition`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-CURReportDefinition.html)
2. [`Get-CECostAndUsage`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-CECostAndUsage.html)
