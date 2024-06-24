# GitHub Action: Create new DevOps Deploy component version

This GitHub Action automates the process of triggering the creation of a new DevOps Deploy component version based on the provided inputs.
This action optionally allows for a version link to be created, files to be uploaded to the version and properties to be set on the version.
This action uses the DevOps Deploy udclient cli to communicate with the DevOps Deploy server and execute the implemented actions.

## Inputs

* `component` (required): The name or ID of the component in DevOps Deploy.
* `versionname` (required): The name of the new component version in DevOps Deploy.
* `description` (optional): Description of the new version.
* `linkName` (optional): The name of the link to add to the component version.
* `link` (optional): URL to add to the component version.
* `base` (optional): Local base directory containing files to upload if file upload is required.
* `offset` (optional): Target path offset (the directory in the version files to which the uploaded files should be added).
* `inlude` (optional): An include file pattern for selecting files to add (may be repeated).
* `exclude` (optional): An exclude file pattern for excluding files (may be repeated).
* `saveExecuteBits` (optional): Flag to specify whether or not to save execute bits for files.
* `versionProperties` (optional): Properties to set on the component version.  Each property must in the following format: \
                                  name:value:secure.  If you have multiple properties, then they should be separated by a \
                                  new-line character.
* `urlType` (optional): URL protocol to use to connect to DevOps Deploy hostname.  Default is "https:".
* `hostname` (required): Hostname or IP of the DevOps Deploy server.
* `port` (required): Port number of the DevOps Deploy server. Defaults to 8443.
* `authToken` (required): Authentication token used to authenticate with the DevOps Deploy server.

## Example Usage

```yaml
name: Create DevOps Deploy Component Version

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    name: A job to create a DevOps Deploy component version with a version link, version files and version properties
    steps:
      - name: Create artifacts to add to component
        id: create-artifacts
        run: mkdir /tmp/artifacts && date > /tmp/artifacts/date.txt
      - name: Set short_commit_id
        id: vars
        run: echo "short_commit_id=$(echo ${{ github.event.head_commit.id }} | cut -c1-7)" >> "$GITHUB_ENV"
      - name: Set optional global flags for udclient command
        id: set-optional-global-flags
        run: echo "UC_TLS_VERIFY_CERTS=false" >> "$GITHUB_ENV"
      - uses: HCL-TECH-SOFTWARE/devops-deploy-createcomponentversion-action@v2devel
        with:
          component: 'MyComp'
          versionname: '${{ env.short_commit_id }}:${{ github.event.head_commit.message }}'
          description: 'Commit ID: ${{ github.event.head_commit.id }} Repository URL: ${{ github.repositoryUrl }}'
          linkName: 'Git Commit'
          link: '${{ github.server_url }}/${{ github.repository }}/commit/${{ github.event.head_commit.id }}'
          base: /tmp/artifacts
          offset: demo/files
          versionProperties: |-
            TestProperty1:DemoValue1:false
            TestProperty2:DemoValue2:false
            TestProperty3:DemoValue3:true
          hostname: 'DevOps_Deploy_Server_hostname'
          port: '8443'
          authToken: '${{ secrets.DEVOPS_DEPLOY_AUTHTOKEN }}'
```
