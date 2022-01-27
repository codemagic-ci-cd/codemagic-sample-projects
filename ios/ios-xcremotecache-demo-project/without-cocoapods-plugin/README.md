## iOS XCRemoteCache 

The **codemagic.yaml** in this project can be used as a starter template for working with XCRemoteCache when building your apps with Codemagic CI/CD.

This example contains workflow based around a native iOS app for a project without Cocoapods dependencies. 

To build the project, first, update the `rcinfo` with the credentials: 

```bash
---
primary_repo: https://linkToTheRepository.git
primary_branch: main 
Cache_addresses: 
  - https:// https://bucketName.s3.ap-south-1.amazonaws.com
aws_secret_key: <Secret Access Key>
aws_access_key: <Access Key ID>
aws_region: ap-south-1
aws_service: s3
``` 

Next, download the XCRemoteCache ZIP file from the release page. 

You can download the universal binary that includes both arm64 and x86_64 architectures. Rename it to xcremotecache, and unzip the bundle next to your .xcodeproj.

Then, build the project on Codemagic to upload the cache to the remote server. The folder contains a sample  **codemagic.yaml** template.

Finally, run pod install on your local machine in **consumer** mode with the following command: 

```bash 
xcremotecache/xcprepare integrate --input <NameOfProject>.xcodeproj --mode consumer=
```