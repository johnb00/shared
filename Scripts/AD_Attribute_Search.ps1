# Active Directory Search Script
# Enter an Active Directory attribute name with a value to search for and display the results either in a GridView window or the Console
# Note: The attribute name must be spelled correctly and work with the -Filter switch
#       This script uses the Active Directory Search Module in C:\Git\shared\Modules

$AD_Attribute_Name = Read-Host "Enter AD attribute name to be used for the search"
$AD_Attribute_Value = Read-Host "Enter $AD_Attribute_Name to search for"
$Output = Read-Host "Do you want the output in the Console or GridView window? (Enter 'Console' or 'GridView')"
Import-Module C:\Git\shared\Modules\AD_Attribute_Search.psm1
ADSearch -Attribute_Name $AD_Attribute_Name -Attribute_Value $AD_Attribute_Value -Output $Output