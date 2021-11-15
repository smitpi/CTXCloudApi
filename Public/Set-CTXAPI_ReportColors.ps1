
<#PSScriptInfo

.VERSION 0.1.1

.GUID 30604ec8-78ac-49d4-956e-2e4d9368b85f

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS ctx ps

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [14/11/2021_03:31] Initital Script Creating
Updated [14/11/2021_07:05] Added more functions

.PRIVATEDATA

#> 




<# 

.DESCRIPTION 
Set the color for html reports

#> 


<#
.SYNOPSIS
Set the color and logo for HTML Reports

.DESCRIPTION
Set the color and logo for HTML Reports. It updates the registry keys in HKCU:\Software\CTXCloudApi with the new details and display a test report.

.PARAMETER Color1
New Background Color # code

.PARAMETER Color2
New foreground Color # code

.PARAMETER LogoURL
URL to the new Logo

.EXAMPLE
Set-CTXAPI_ReportColors -Color1 '#d22c26' -Color2 '#2bb74e' -LogoURL 'https://gist.githubusercontent.com/default-monochrome.png'

#>
# .ExternalHelp  CTXCloudApi-help.xml
Function Set-CTXAPI_ReportColors {
	[Cmdletbinding()]
	PARAM(
		[string]$Color1 = '#061820',
		[string]$Color2 = '#FFD400',
		[string]$LogoURL = 'https://c.na65.content.force.com/servlet/servlet.ImageServer?id=0150h000003yYnkAAE&oid=00DE0000000c48tMAA'
	)
    
	$mod = Import-Module CTXCloudApi -Force -PassThru
	$file = Get-Item (Join-Path $mod.ModuleBase -ChildPath '\Private\Reports-Colors.ps1')
	Import-Module $file.FullName
 
	Set-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name Color1 -Value $($Color1)
	Set-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name Color2 -Value $($Color2)
	Set-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name LogoURL -Value $($LogoURL)

	Import-Module CTXCloudApi -Force

	[string]$HTMLReportname = $env:TEMP + '\Test-color' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.html'

	$HeadingText = 'Test | Report | ' + (Get-Date -Format dd) + ' ' + (Get-Date -Format MMMM) + ',' + (Get-Date -Format yyyy) + ' ' + (Get-Date -Format HH:mm)

	New-HTML -TitleText 'Report' -FilePath $HTMLReportname -ShowHTML {
		New-HTMLLogo -RightLogoString $CTXAPI_LogoURL
		New-HTMLHeading -Heading h1 -HeadingText $HeadingText -Color Black
		New-HTMLSection @SectionSettings -HeaderText 'Test' -Content {
			New-HTMLSection -HeaderText 'Test2' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable (Get-Process | Select-Object -First 5) }
			New-HTMLSection -HeaderText 'Test3' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable (Get-Service | Select-Object -First 5) }
		}
	}

} #end Function
