
<#PSScriptInfo

.VERSION 1.1.1

.GUID a5a616ca-f8e9-4c5c-9d71-03fddfe2ee0d

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS ps

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [04/10/2021_21:49] Initital Script Creating
Updated [05/10/2021_08:29] 'Moved to a new module'

.PRIVATEDATA

#> 





<# 

.DESCRIPTION 
Creates a pode web project

#> 

Param()


Function New-PodeWebProject {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $ProjectName,
        [Parameter(Mandatory)]
        [ValidateScript( {
                If (-not(Test-Path $_)) {
                    Throw "A valid path is required"
                }
                Else { $true }
            }
        )]
        [string] $Destination,
        [ValidateRange(1, 65535)]
        [string] $Port = 80,
        [ValidateSet("http", "https")]
        [string]$Protocol = 'http',
        [string]$Address = 'localhost',
        [ValidateSet("dark", "light")]
        [string]$Theme = 'light',
        [Switch] $SetAsCurrentLocation

    )
    Begin {
        $TemplateRoot = (Split-Path $PSScriptRoot -Parent)
        $ProjectRoot = (Join-Path $Destination $ProjectName)

    }

    Process {
        If (Test-Path $ProjectRoot) {
            Write-Error "Project exists at '$ProjectRoot'. Please choose a different path."
            break;
        }
        
        New-Item -ItemType Directory -Path $ProjectRoot > $null
        

        #Region Create directory structure and files
        $Folders = @(
            'assets'
            'pages'
            'src'
        )
        Foreach ($folder in $Folders) {
            $NewItemSplat = @{
                ItemType    = 'Directory'
                Path        = (Join-Path $ProjectRoot $folder)
                ErrorAction = 'SilentlyContinue'
            }
            New-Item @NewItemSplat > $null
        }

        # Setup config files within the new project root
        
        Get-Content  (Join-Path $TemplateRoot "Private\dashboard_Template.ps1") | 
        Set-Content (Join-Path $ProjectRoot "dashboard.ps1")

        $Configuration = @{
            'Dashboard' = @{
                'Port'       = $Port
                'Protocol'   = $Protocol
                'Address'    = $Address
                'Theme'      = $theme 
                'Title'      = $ProjectName
                'RootModule' = "$ProjectName.psm1"
            }
        }

        $Configuration | ConvertTo-Json -Depth 99 | Set-Content -Path (Join-Path $ProjectRoot dbconfig.json)

        # Create the module manifest psd1 for the project
        
        $ModuleManifestSplat = @{
            'Path'       = "{0}.psd1" -f (Join-Path $ProjectRoot $ProjectName)
            'RootModule' = "$ProjectName.psm1"
        }

        New-ModuleManifest @ModuleManifestSplat

        # Create the module psm1 file for the project

        $ModuleFileContents = @'
$Source = Get-ChildItem (Join-Path $PSScriptRoot src) -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue

Foreach ($import in $Source) {
    . $import.fullname
}
'@
        $ModuleFile = "{0}.psm1" -f (Join-Path $ProjectRoot $ProjectName)

        New-Item $ModuleFile > $null

        Set-Content -Path $ModuleFile -Value $ModuleFileContents

        # Create a default empty home page

        $HomePage = @'
Set-PodeWebHomePage -Layouts @(
    New-PodeWebHero -Title "Welcome! $($env:USERNAME)" -Message 'Hi' -Content @()
)
'@
        $HomePage | Set-Content (Join-Path (Join-Path $ProjectRoot pages) home.ps1)

        If ($SetAsCurrentLocation) {
            Set-Location $ProjectRoot
        }

        [PSCustomObject]@{
            'Name'               = $ProjectName
            'Root Module'        = $Configuration.dashboard.rootmodule
            'Configuration File' = (Join-Path $ProjectRoot dbconfig.json)
        }
    }
}
