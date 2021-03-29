# Windows 10 Pro Configuration

# PreReq - Open elevated PowerShell command prompt and run:
    # Set-WSManQuickConfig (or 'winrm quickconfig')
    # Change Local Execution Policy to allow DSC script to run:
    # Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Unrestricted -Force

# To check DSC status:
    # Get-DscConfigurationStatus
    # Add ' | fl' to view more details, including resources in/not in the desired state
# To test DSC state:
    # Test-DscConfiguration
    # Test returns True if DSC is in the desired state, False if at least one resource is not in the desired state
# To remove any existing DSC configurations:
    # Remove-DscConfigurationDocument -Stage Current,Pending,Previous -Force -Verbose

    # Import list of Windows Features
$Win10ProFeatures = Get-Content ".\Win10ProFeatures.txt"
# Start Configuration
Configuration Win10Pro {
    # Import DSC Module
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node localhost {
        #region File/Folder Resources
        File TempDir {
            Ensure = "Present"
            Type = "Directory"
            DestinationPath = "C:\Temp"
        }
        #endregion File/Folder Resources
        #region Windows Features
        # View Feature Names: Get-WindowsOptionalFeature -Online | Sort | Ft
        # Loop through imported list of Windows Features
        foreach ($WinFeature in $Win10ProFeatures) {
            # Custom Script Resource for each Windows Feature
            Script $WinFeature {
                # GetScript will run when using Get-DscConfiguration to get the node's state.
                # If you specify a return value, it must be a hashtable containing a 'Result' key whose value is a String.
                GetScript = {
                    $using:WinFeature
                    $CheckForFeature = Get-WindowsOptionalFeature -Online -FeatureName $WinFeature | Select-Object DisplayName,FeatureName,State,Online
                    [string]$FeatureState = $CheckForFeature.State
                    @{ Result = $FeatureState }
                }
                # TestScript will check for the feature and its returned value will impact SetScript.
                # If it's enabled, return true to skip the install. If it's disabled, return false to trigger the install.
                TestScript = {
                    $using:WinFeature
                    $CheckForFeature = Get-WindowsOptionalFeature -Online -FeatureName $WinFeature | Select-Object DisplayName,FeatureName,State,Online
                    if ($CheckForFeature.State -eq "Disabled") {
                        Write-Verbose -Message "$WinFeature is disabled, running SetScript to install feature."
                        return $false
                    }
                    else {
                        Write-Verbose -Message "$WinFeature is enabled. No action is required."
                        return $true
                    }
                }
                # Install feature if TestScript returns $false
                SetScript = {
                    $using:WinFeature
                    Enable-WindowsOptionalFeature -Online -FeatureName $WinFeature
                }
            }
        }
        #endregion Windows Features
        #region Local Configuration Manager
        LocalConfigurationManager {
            # Allows Pull service to overwrite the configuration with a new one
            # Keeping this in place just in case we switch to the Pull service
            AllowModuleOverwrite = $true
            # Check Configuration every 24 Hours
            ConfigurationModeFrequencyMins = 1440
            # Default value - After the config is initially applied, DSC will check the state and report any discrepancies in logs
            ConfigurationMode = "ApplyAndMonitor"
            # Default value - You can allow resources to reboot if a config change requires it
            RebootNodeIfNeeded = $false
            # Default value - Manually apply the config using the cmdlet
            RefreshMode = "Push"
        }
        #endregion Local Configuration Manager
    }
}
# Call the configuration to compile it into a MOF file
Win10Pro -OutputPath C:\DSC\Win10Pro
# Apply the configuration to the localhost using the path of the MOF file
# Run this in an elevated PowerShell command window or PowerShell ISE (does not work if running from VS Code)
Start-DscConfiguration -Path C:\DSC\Win10Pro -Verbose -Wait -ErrorAction Stop
# Apply the LCM settings
Set-DscLocalConfigurationManager -Path C:\DSC\Win10Pro