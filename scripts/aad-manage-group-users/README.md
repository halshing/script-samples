---
plugin: add-to-gallery
---

# Bulk add/remove users to Microsoft Teams and Microsoft 365 Groups

## Summary

Companies pursue to hasten profits growth or enter new marketplace through Mergers and Acquisitions (M&A). M&A typically fails during integration. This also applies to migrating users and data in Microsoft Teams and Groups. Partial acquisition can be pretty tricky. 

To help make the activity as charming as possible, I have created the following sample script to add/remove bulk users to/from Microsoft Teams team or Microsoft 365 group.
 
> [!Note]
> Refactor the code as per your requirement.
 
# [CLI for Microsoft 365 with PowerShell](#tab/cli-m365-ps)
```powershell
$taskItems = import-csv "sample-input-file.csv" –header mailNickname, userEmail, role, action
$groups = m365 aad o365group list -o json | ConvertFrom-Json

ForEach ($taskItem in $taskItems) {

    $mailNickname = $($taskItem.mailNickname)
    $userEmail = $($taskItem.userEmail)
    $role = $($taskItem.role)
    $action = $($taskItem.action)

    $group = $groups | Where-Object { $_.mailNickname -eq "$mailNickname" }
    $user = m365 aad user get --userName $userEmail -o json | ConvertFrom-Json

    Write-Host "Processing: User --> " $user.mail " Group --> " $group.mailNickname

    If ($action -eq "add") {

        If ($role -eq "owner") {
            m365 aad o365group user add --groupId $group.id --userName $user.mail --role Owner; 
            Write-Host $user.mail " added as owner in " $group.mailNickname
        }
        ElseIf ($role -eq "member") {
            m365 aad o365group user add --groupId $group.id --userName $user.mail
            Write-Host $user.mail " added as member in " $group.mailNickname
        }
        Else {
            Write-Host "Invalid user role '" $role "'"
        }
    }
    ElseIf ($action -eq "remove") {
        m365 aad o365group user remove --groupId $group.id --userName $user.mail --confirm
        Write-Host $user.mail " removed from " $group.mailNickname
    }
    Else {
        Write-Host "Invalid task action '" $action "'"
    }
}
```

# [CSV File](#tab/csv)
```powershell
groupMailNickname1, user1@domainname.com, owner, add
groupMailNickname2, user2@domainname.com, member, add
groupMailNickname3, user3@domainname.com, , remove
```
***

## Source Credit

Sample first appeared on [Bulk add/remove users to Microsoft Teams and Microsoft 365 Groups | CLI for Microsoft 365](https://pnp.github.io/cli-microsoft365/sample-scripts/aad/manage-group-users/)

## Contributors

| Author(s) |
|-----------|
| Joseph Velliah |


[!INCLUDE [DISCLAIMER](../../docfx/includes/DISCLAIMER.md)]
<img src="https://telemetry.sharepointpnp.com/script-samples/scripts/aad-manage-group-users" aria-hidden="true" />