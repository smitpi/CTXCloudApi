#
# Module manifest for module 'CTXCloudApi'
#
# Generated by: Pierre Smit
#
# Generated on: 2022-03-20 13:32:04Z
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'CTXCloudAPI.psm1'

# Version number of this module.
ModuleVersion = '0.1.31'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '8eb35bf0-e1d3-4b42-9285-d8010a1c13a7'

# Author of this module
Author = 'Pierre Smit'

# Company or vendor of this module
CompanyName = 'HTPCZA Tech'

# Copyright statement for this module
Copyright = '(c) 2021 Pierre Smit. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Wrapper for Citrix Cloud CVAD API. You dont require the installed SDK anymore. With this module you can manage your clients cloud infrastructure from anywhere. Start with Connect-CTXAPI to connect, it will create the needed hearders for the other functions.'

# Minimum version of the PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @('ImportExcel', 
               'PSWriteHTML', 
               'PSWriteColor')

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Connect-CTXAPI', 'Get-CTXAPI_Application', 
               'Get-CTXAPI_CloudConnector', 'Get-CTXAPI_CloudService', 
               'Get-CTXAPI_ConfigAudit', 'Get-CTXAPI_ConfigLog', 
               'Get-CTXAPI_ConnectionReport', 'Get-CTXAPI_DeliveryGroup', 
               'Get-CTXAPI_FailureReport', 'Get-CTXAPI_HealthCheck', 
               'Get-CTXAPI_Hypervisor', 'Get-CTXAPI_LowLevelOperation', 
               'Get-CTXAPI_Machine', 'Get-CTXAPI_MachineCatalog', 
               'Get-CTXAPI_MonitorData', 'Get-CTXAPI_ResourceLocation', 
               'Get-CTXAPI_ResourceUtilization', 'Get-CTXAPI_Session', 
               'Get-CTXAPI_SiteDetail', 'Get-CTXAPI_Test', 'Get-CTXAPI_VDAUptime', 
               'Get-CTXAPI_Zone', 'Set-CTXAPI_ReportColour', 'Test-CTXAPI_Header'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
# VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'api','citrix','cloud','ctx','cvad','xenapp','xendesktop'

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/smitpi/CTXCloudApi'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = 'Updated [29/01/2022_09:01] Online help is now working from the command line.'

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

 } # End of PrivateData hashtable

# HelpInfo URI of this module
HelpInfoURI = 'https://smitpi.github.io/CTXCloudApi/'

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

