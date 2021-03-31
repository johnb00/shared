# PowerShell Scripts
Active Directory Search scripts

Suggested Use Case - to allow a lower tier (or team with read-only access) to run searches without using any Active Directory tools. The script could be launched from a citrix server to reduce the user's access.
Requirements - Active Directory PowerShell module
- AD_EmployeeID_Search.ps1 reads your input and searches the employeeID attribute
- AD_Attribute_Search.ps1 reads your input for the attribute of your choosing, the value of what to search for, and where you want to see the output
  - This was derived after the EmployeeID search, thinking 'what if I wanted to search for something else'
  - This script uses my Active Directory Search Module

Background Job Template script
- ParallelJob_Template.ps1 is an example of a wrapper to run commands or a software installation using background jobs in an elevated PowerShell session
  - This is a simple alternative to the ForEach -Parallel which only runs in a PowerShell WorkFlow
  - This was derived from my own need to bulk update a 3rd party application across a large number of servers in short maintenance window