# VSTS Settings
$Organization = "{Azure Devops Organization}"
$Project = "{Azure Devops Project}"

$user = "{Service Account Email}"
$token = "{Service Account Token (Requires Scope: Variable Groups(Read & Create))}"

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))

$newVariableJson = @"
{
    "variables": {
      "BranchLifecycle": {
        "value": ""
      },
      "LifeCycle": {
        "value": "",
      },
      "BranchSuffix": {
        "value": "",
      }
    },
    "type": "Vsts",
    "name": "Build And Release Variables",
    "description": "Variables used by the Derive Build Param Script"
}
"@

$updateUrl = "https://dev.azure.com/$Organization/$Project/_apis/distributedtask/variablegroups/?api-version=5.0-preview.1"

Invoke-RestMethod -Uri $updateUrl -Method POST -ContentType "application/json" -body $newVariableJson -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}