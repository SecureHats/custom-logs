![logo](https://raw.githubusercontent.com/SecureHats/SecureHacks/main/media/sh-banners.png)
=========
[![Maintenance](https://img.shields.io/maintenance/yes/2022.svg?style=flat-square)]()
# Microsoft Sentinel - Custom Logs Ingestor

This GitHub action can be used to send custom log data to Microsoft Sentinel in both JSON and CSV format.<br />
By default all files in the monitored folder will be send to the Log Analytics workspace.

### Example 1

> Add the following code block to your Github workflow:

```yaml
name: CustomLogs
on:
  push:
    paths:
      - samples/**

jobs:
  custom-logs:
    name: Custom Logs
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository code
        uses: actions/checkout@v3
      - name: Microsoft Sentinel Custom Logs
        uses: SecureHats/custom-logs@v1.0
        with:
          filesPath: samples
          workspaceId: ${{ secrets.WORKSPACEID }}
          workspaceKey: ${{ secrets.WORKSPACEKEY }}
```

### Example 2 only send changed files

> To upload only the changed files add the `tj-actions/changed-files` action to the pipeline.<br />
> The output value from this action can be used as an input value for the `filesPath` parameter.

```yaml
      - name: Get changed files
        id: changed-files
        uses: tj-actions/changed-files@v23.1
        with:
          separator: ","
      
      - name: Microsoft Sentinel Custom Logs
        uses: SecureHats/custom-logs@v1.0
        with:
          filesPath: '${{ steps.changed-files.outputs.all_changed_files }}'
          workspaceId: ${{ secrets.WORKSPACEID }}
          workspaceKey: ${{ secrets.WORKSPACEKEY }}
```

### Inputs

This Action defines the following format inputs.

| Name | Req | Description
|-|-|-|
| **`filesPath`**  | false | Path to the directory containing the log files to be send, relative to the root of the project.<br /> This path is optional and defaults to the project root, in which case all files CSV files and JSON wills across the entire project tree will be discovered.
| **`workspaceId`** | true | The workspace-id of the Log Analytics workspace.<br /> This value needs to be provided as a GitHub secret. see [documentation](https://github.com/Azure/actions-workflow-samples/blob/master/assets/create-secrets-for-GitHub-workflows.md) on how to create secrets in GitHub
| **`workspaceKey`** | true | The primary or secondary key of the Log Analytics workspace.<br /> This value needs to be provided as a GitHub secret. see [documentation](https://github.com/Azure/actions-workflow-samples/blob/master/assets/create-secrets-for-GitHub-workflows.md) on how to create secrets in GitHub
| **`separator`** | false | Split character for when providing an array of values. when left empty a comma is used.
 

## Current limitations / Under Development

- Filesize limit for CSV 100 MB
- Support for more file formats
