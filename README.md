![logo](https://raw.githubusercontent.com/SecureHats/SecureHacks/main/media/sh-banners.png)
=========
[![Maintenance](https://img.shields.io/maintenance/yes/2022.svg?style=flat-square)]()
# Microsoft Sentinel - Custom Logs Ingestor

This GitHub action can be used to send custom log data to Microsoft Sentinel in both JSON and CSV format.
> Add the following code block to your Github workflow:

```yaml
name: CustomLogs
on: push

jobs:
  custom-logs:
    name: validate detections
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository code
        uses: actions/checkout@v3
      - name: Microsoft Sentinel Custom Logs
        uses: SecureHats/custom-logs@v1
        with:
          filesPath: samples
```

### Inputs

This Action defines the following format inputs.

| Name | Req | Description
|-|-|-|
| **`filesPath`**  | false | Path to the directory containing the log files to be send, relative to the root of the project. This path is optional and defaults to the project root, in which case all files CSV files and JSON wills across the entire project tree will be discovered. 


## Current limitations / Under Development

- Filesize limit for CSV 100 MB
- Support for more file formats
