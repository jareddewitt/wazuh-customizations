##########################################
## sysmon installation                  ##
##########################################
$ApplicationName = "sysmon" ## Application Name

#### Don't Modify Anything below this line
$computer = read-host "Computer Name:"
$creds = Get-Credential ## Get credentials to install
$source = "C:\temp"  #If running from a different source.  Consider changing this to read what directory it is running from.

# Map drive to remote computer
Remove-PSDrive -name "temp"
New-PSDrive -PSProvider FileSystem -Name "temp" -Root \\$computer\c$\windows\temp -Credential $creds
    
# copy the files over
Copy-Item $source temp:\$ApplicationName -Force -Recurse


## Won't work unless you pass the application name through an argument
Invoke-Command -Credential $creds -computer $computer -ScriptBlock {
    param($ApplicationName)
        cmd /c c:\windows\temp\$ApplicationName\install.cmd
} -ArgumentList $ApplicationName

    
## Delete the remote files and cleanup
Remove-Item temp:\$ApplicationName -Force -Recurse

## Clean up drive (Consider moving this to a function for cleanup)
Remove-PSDrive -name "temp"