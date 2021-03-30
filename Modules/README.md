# PowerShell Modules
Active Directory Attribute Search Module

Requirements - Active Directory PowerShell module

Example usage:
- Import-Module C:\Git\shared\Modules\AD_Attribute_Search.psm1 -Verbose
- ADSearch -Attribute_Name "employeeid" -Attribute_Value "12345" -Output GridView

Possible Update - Add a validation set with all attribute names that work with the Get-ADUser -Filter parameter
