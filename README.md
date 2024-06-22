# GitHub Action: Create new DevOps Deploy component version

This GitHub Action automates the process of triggering the creation of a new DevOps Deploy component version based on the provided inputs.

## Inputs

* `component` (required): The name or ID of the component in DevOps Deploy.
* `versionname` (required): The name of the new component version in DevOps Deploy.
* `description` (optional): Description of the new version.
* `link` (optional): URL to add to the component version.
* `hostname` (required): Hostname or IP of the DevOps Deploy server.
* `port` (required): Port number of the DevOps Deploy server. Defaults to 8443.
* `username` (username:password or authToken is required): Username used to authenticate with the DevOps Deploy server.
* `password` (username:password or authToken is required): Password used to authenticate with the DevOps Deploy server.
* `authToken` (username:password or authToken is required): Authentication token used to authenticate with the DevOps Deploy server.  This will override the username:password if specified.
* `disableSSLVerification` (optional): A boolean value indicating whether to skip SSL certificate validation when making HTTPS requests. Default is `false`.

## Example Usage

```yaml
name: Create DevOps Deploy Component Version

on:
  push:
    branches:
      - master

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Set short_commit_id
      id: vars
      run: echo "short_commit_id=$(echo ${{ github.event.head_commit.id }} | cut -c1-7)" >> "$GITHUB_ENV"
    - name: Create Component Version
      uses: HCL-TECH-SOFTWARE/devops-deploy-createcomponentversion-action@v1.0
      with:
        component: 'MyComp'
        versionname: '${{ env.short_commit_id }}:${{ github.event.head_commit.message }}'
        description: 'Commit ID: ${{ github.event.head_commit.id }} Repository URL: ${{ github.repositoryUrl }}'
        link: '${{ github.server_url }}/${{ github.repository }}/commit/${{ github.event.head_commit.id }}'
        hostname: 'DevOps_Deploy_Server_hostname'
        port: '8443'
        authToken: '${{ secrets.DEVOPS_DEPLOY_AUTHTOKEN }}'
```
