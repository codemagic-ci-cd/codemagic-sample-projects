## iOS XCRemoteCache 

The **codemagic.yaml** in this project can be used as a starter template for working with XCRemoteCache when building your apps with Codemagic CI/CD.

This example contains workflow based around a native iOS app for a project without Cocoapods dependencies. 

To build the project, first, update the `Podfile` with the credentials: 

```bash
plugin 'cocoapods-xcremotecache'

xcremotecache({
    'cache_addresses' => ['https://bucketName.s3.ap-south-1.amazonaws.com/'], 
    'primary_repo' => 'https://linkToTheRepository.git',
    'mode' => 'producer',
    'final_target' => '<Name of Target>',
    'primary_branch' => 'main',
    'aws_secret_key' => '<Secret Access Key>',
    'aws_access_key' => '<Access Key ID>',
    'aws_region' => 'ap-south-1',
    'aws_service' => 's3'
})
``` 

Then, build the project on Codemagic to upload the cache to the remote server. The folder contains a sample  **codemagic.yaml** template.

Finally, update the `Podfile` with the mode as **consumer** and run pod install on your local machine.