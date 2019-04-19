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

## EC2

### Unofficial Commands

These don't have any error handling, but use a trick only seen in some of AWS documentation:

```powershell
function Get-EC2InstanceMetadata {
  param([string]$Path)
  (Invoke-WebRequest -Uri "http://169.254.169.254/latest/$Path").Content 
}

# You can pass this into `Get-EC2Instance` like so: `Get-EC2Instance -Instance $(Get-EC2InstanceId)`
function Get-EC2InstanceId {
  Get-EC2InstanceMetadata "meta-data/instance-id"
}

function Get-EC2BlockDeviceMapping {
  Get-EC2InstanceMetadata "meta-data/block-device-mapping"
}

function Get-EC2BlockDeviceName {
  param([string]$VirtualDevice)
  Get-EC2InstanceMetadata "meta-data/block-device-mapping/$VirtualDevice"
}
```

### Official Commands

1. [`Get-EC2Instance`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-EC2Instance.html)
    1. IAM Policy Permission: AmazonEC2ReadOnlyAccess

### Windows EC2 Volumes

https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ec2-windows-volumes.html#windows-list-disks

## S3

1. [`Get-S3Bucket`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-S3Bucket.html)
2. [`Get-S3ACL -BucketName <bucket>`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-S3ACL.html)
3. [`Get-S3BucketAccelerateConfiguration -BucketName <bucket>`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-S3BucketAccelerateConfiguration.html)
    1. Returns null if not configured.
4. [`Get-S3BucketAnalyticsConfiguration -BucketName <bucket>`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-S3BucketAnalyticsConfiguration.html)
    1. Will return an empty text table with three column headers (AnalyticsId, AnalyticsFilter, StorageClassAnalysis) if not configured: 
5. [`Get-S3BucketAnalyticsConfigurationList -BucketName <bucket>`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-S3BucketAnalyticsConfigurationList.html)
    1. Will return a single row with sparse data if not configured.
6. [`Get-S3BucketEncryption -BucketName <bucket>`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-S3BucketEncryption.html)
    1. Will return ServerSideEncryptionRules collection
7. [`Get-S3BucketInventoryConfiguration -BucketName <bucket>`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-S3BucketInventoryConfiguration.html)
    1. TODO need to better understand what this manages
8. [`Get-S3BucketLocation -BucketName <bucket>`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-S3BucketLocation.html)
    1. By default returns an object with an empty Value property.
9. [`Get-S3BucketLogging -BucketName <bucket>`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-S3BucketLogging.html)
    1. Will return empty table if not configured.
10. [`Get-S3BucketMetricsConfiguration -BucketName <bucket>`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-S3BucketMetricsConfiguration.html)
    1. Will return empty table if not configured.
11. [`Get-S3BucketMetricsConfigurationList -BucketName <bucket>`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-S3BucketMetricsConfigurationList.html)
    1. Will return empty table if not configured.
12. [`Get-S3BucketNotification -BucketName <bucket>`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-S3BucketNotification.html)
     1. Will return empty table if not configured.
13. [`Get-S3BucketPolicy -BucketName <bucket>`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-S3BucketPolicy.html)
     1. Will return a JSON object
     2. Use `Get-S3BucketPolicy -BucketName <bucket> | ConvertFrom-Json` instead

## Billing

1. [`Get-CURReportDefinition`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-CURReportDefinition.html)
2. [`Get-CECostAndUsage`](https://docs.aws.amazon.com/powershell/latest/reference/items/Get-CECostAndUsage.html)

## Response Logging

https://aws.amazon.com/blogs/developer/response-logging-in-aws-tools-for-windows-powershell/
