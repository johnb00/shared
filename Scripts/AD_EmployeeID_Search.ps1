# Search Active Directory for an Employee ID and display the results in a GridView window
# Multiple results are easier to view this way instead of scrolling
Import-Module ActiveDirectory
$employeeID = Read-Host "Enter Employee ID to search for"
Get-ADUser -Filter {employeeID -eq $employeeID} -Properties employeeID | Out-GridView

<# Alternative Script to view results in a Console Window, one at a time
Import-Module ActiveDirectory
$employeeID = Read-Host "Enter Employee ID to search for"
$employeeID_Results = Get-ADUser -Filter {employeeID -eq $employeeID} -Properties employeeID
Write-Host "Number of results found: $($employeeID_Results.count)"
foreach ($employee in $employeeID_Results) {
    $employee
    Read-Host "Press Enter to continue"
}
#>