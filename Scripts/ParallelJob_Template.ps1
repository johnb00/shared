# Parallel Job Template
# Example wrapper to run commands or a software installation using background jobs in an elevated PowerShell session

# Pull list of servers
$list = Get-Content "C:\Temp\server_list.txt"
# Enter administrative credentials
$creds = Get-Credential -Message "Enter your administrative account credentials"

# Loop through each server and start a scriptblock as a background job
foreach ($server in $list) {
    Start-Job -ScriptBlock {
        param($server,$creds)
        # Create elevated session
        $session = New-PSSession -ComputerName $server -Authentication Credssp -Credential $creds
        # Invoke elevated commands or installer
        Invoke-Command -Session $session -ScriptBlock {
            # cmd /c will run the command in the quotes in a new shell then terminate
            cmd /c "C:\Temp\installer.exe"
            # alternative for an MSI installer
            #Start-Process -FilePath msiexec "/i C:\Temp\installer.msi /qn" -Wait
        } -ErrorAction Stop
        # Remove the session when finished
        Remove-PSSession $session
    } -ArgumentList $server,$creds | Out-Null
}
# Using this piped Get/Wait/Receive-Job at the end of the script will keep it in a running state until all the jobs complete
Get-Job | Wait-Job | Receive-Job -Keep

# Alternatively, you can exclude the piped Get/Wait/Receive-Job, then check on the status with Get-Job and when complete, use Receive-Job to see the output
# Receive-Job -Keep retains the output returned by the completed job. If you exclude -Keep, you only see output the first time you run Receive-Job