# Active Directory Search Module
# Enter an Active Directory attribute name with a value to search for and display the results either in a GridView window or the Console
# Note: The attribute name must be spelled correctly and work with the -Filter switch
# Example usage:
# Import-Module C:\Git\shared\Modules\AD_Attribute_Search.psm1 -Verbose
# ADSearch -Attribute_Name "employeeid" -Attribute_Value "12345" -Output GridView
function ADSearch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,Position=1)]
            [string]$Attribute_Name,
        [Parameter(Mandatory=$true,Position=2)]
            [string]$Attribute_Value,
        [Parameter(Mandatory=$true,Position=3)]
            [ValidateSet("Console,GridView")]
            [string]$Output
    )
    Import-Module ActiveDirectory
    $AD_Results = Get-ADUser -Filter {$Attribute_Name -eq $Attribute_Value} -Properties $Attribute_Name
    if ($Output -eq "GridView") {
        $AD_Results | Out-GridView
    }
    if ($Output -eq "Console") {
        Write-Host "Number of results found: $($AD_Results.count)"
        foreach ($result in $AD_Results) {
            $result
            Read-Host "Press Enter to continue"
        }
    }
}