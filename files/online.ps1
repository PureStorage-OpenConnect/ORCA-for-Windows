#
$CurrentID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$CurrentPrincipal = new-object System.Security.Principal.WindowsPrincipal($CurrentID)
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator
$UserName = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
#
write-host "Welcome " $UserName
#
# Check to see if session is currently with admin privileges
#
if ($CurrentPrincipal.IsInRole($adminRole)) {
    write-host "Yes we are running elevated."
}else{
    write-host "No this is a normal user session."
}
#  

$TargetVM = 'z-re-ora-dev2.uklab.purestorage.com'

# Use wmic diskdrive get serialnumber to get disk Serial Number
# E:\ 50C939582B0F46C0003E2D24
# F:\ 50C939582B0F46C0003E59A6

$TargetVMSession = New-PSSession -ComputerName $TargetVM

# Online the volume
Write-Host "Onlining the volumes..." -ForegroundColor Red
Invoke-Command -Session $TargetVMSession -ScriptBlock { Get-Disk | ? { $_.SerialNumber -eq '50C939582B0F46C0003E2D24' } | Set-Disk -IsOffline $False }
Invoke-Command -Session $TargetVMSession -ScriptBlock { Get-Disk | ? { $_.SerialNumber -eq '50C939582B0F46C0003E59A6' } | Set-Disk -IsOffline $False }

Write-Host "Development volumes online" -ForegroundColor Red

# Clean up
Remove-PSSession $TargetVMSession
Write-Host "All done." -ForegroundColor Red 

