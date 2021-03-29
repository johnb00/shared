# DSC
Win10ProConfig.ps1 - Tested on Windows 10 Pro Version 20H2

A simple DSC configuration to install Windows Features on Workstations using Custom Script Resources.
The built-in WindowsFeature resource is only supported on Servers.

- Creates a C:\Temp folder
- Installs the Windows Features listed in Win10ProFeatures.txt
  - Win10ProFeatures.txt must be in the active directory