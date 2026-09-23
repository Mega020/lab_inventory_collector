$os = Get-CimInstance -ClassName CIM_OperatingSystem
$bios = Get-CimInstance -ClassName CIM_BIOSElement
$proc = Get-CimInstance -ClassName CIM_Processor | Select-Object -First 1
$logdsk = Get-CimInstance -ClassName CIM_LogicalDisk |
    Where-Object DriveType -eq 3 |
    Measure-Object -Property Size -Sum

$data = [PSCustomObject]@{
    "Hostname" = $os.CSName
    "Service Tag" = $bios.SerialNumber
    "OS" = $os.Caption.Replace("Microsoft", "").Trim()
    "CPU" = $proc.Name
    "RAM" = "$($os.TotalVisibleMemorySize/1MB -as [int]) GB"
    "Storage" = "$($logdsk.Sum/1GB -as [int]) GB"
}

$filePath = "\\PSREMOTESESSION\Data\Inventory.csv"

if (Test-Path -Path $filePath) {
    $data | Export-Csv -Path $filePath -Append -NoTypeInformation
} else {
    $data | Export-Csv -Path $filePath -NoTypeInformation

    $acl = Get-Acl -Path $filePath
    $acl.SetAccessRuleProtection($false, $true)
    Set-Acl -Path $filePath -AclObject $acl
}
