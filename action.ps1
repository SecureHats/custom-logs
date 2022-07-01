<#
    Title:          Custom Logs Ingestion
    Language:       PowerShell
    Version:        1.0
    Author:         Rogier Dijkman
    Last Modified:  05/26/2022

    DESCRIPTION
    This GitHub action is used to upload custom data to a log analytics workspace.
    The input can be either JSON or CSV formatted. This function will build the signature and authorization header needed to
    post the data to the Log Analytics workspace via the HTTP Data Connector API.

    The GitHub action will post each log type to their individual tables in Log Analytics, for example,
    SecureHats_CL. If the filename ends with _CL the name of the file will be used as the table name
#>

param (
    [parameter(Mandatory = $true)]
    [array]$FilesPath,

    [parameter(Mandatory = $true)]
    [string]$WorkspaceId,

    [parameter(Mandatory = $true)]
    [string]$WorkspaceKey,

    [parameter(Mandatory = $false)]
    [string]$TableName,
    
    [parameter(Mandatory = $false)]
    [string]$Separator
)

# Import custom modules
Get-ChildItem $($PSScriptRoot)
Import-Module "$($PSScriptRoot)/modules/HelperFunctions.psm1"

$parameters = @{
    workspaceId   = $WorkspaceId
    workspaceKey  = $WorkspaceKey | ConvertTo-SecureString -AsPlainText -Force
    tableName     = $TableName
    dataInput     = ''
}

if ($null -ne "$Separator") {
    $FilesPath = $FilesPath -split ("$Separator")
}

$files = Get-ChildItem -Path @($FilesPath) | ForEach-Object {
    if ($_.FullName -like "*.csv") {
        try {
            $parameters.dataInput = (Get-Content $_.FullName | ConvertFrom-CSV)
            if ($_.BaseName -like "*_CL") {
                $parameters.tableName = ($_.BaseName).Replace('_CL', '')
            }
            $response = Send-CustomLogs @parameters
        }
        catch { Write-Host "Unable to process CSV file [$_]" }
    } elseif ($_.FullName -like "*.json") {
        try {
            $parameters.dataInput = (Get-Content $_.FullName | ConvertFrom-JSON)
            if ($_.BaseName -like "*_CL") {
                $parameters.tableName = ($_.BaseName).Replace('_CL', '')
            }
            $response = Send-CustomLogs @parameters
        }
        catch { Write-Host "Unable to process JSON file [$_]" }
    } else {
        if ($files.count -eq 0) { Write-Host "Nothing to progress" }
    }
}

write-Host $response
