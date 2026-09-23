$folderPath = "\\PSREMOTESESSION\Data\Staging"
$filePath = "\\PSREMOTESESSION\Data\Inventory.csv"

Get-ChildItem -Path $folderPath | ForEach-Object {
    Import-Csv -Path $_.PSPath.Replace("Microsoft.PowerShell.Core\FileSystem::", "").Trim() |
    Export-Csv -Path $filePath -Append -NoTypeInformation
}

Remove-Item -Path "$folderPath\*" -Recurse -Force
    