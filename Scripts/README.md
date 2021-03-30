# PowerShell Scripts
Active Directory Search scripts

Suggested Use Case - to allow a lower tier (or team with read-only access) to run searches without using any Active Directory tools. The script could be launched from a citrix server to reduce the user's access.
Requirements - Active Directory PowerShell module
- AD_EmployeeID_Search.ps1 reads your input and searches the employeeID attribute
- AD_Attribute_Search.ps1 reads your input for the attribute of your choosing, the value of what to search for, and where you want to see the output
  - This was derived after the EmployeeID search, thinking 'what if I wanted to search for something else'
  - This script uses my Active Directory Search Module
