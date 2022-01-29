
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
Created [14/11/2021_03:31] Initial Script Creating
Updated [14/11/2021_07:05] Added more functions

.PRIVATEDATA

#>




<#

.DESCRIPTION
Set the colour for html reports

#>


<#
.SYNOPSIS
Set the colour and logo for HTML Reports

.DESCRIPTION
Set the colour and logo for HTML Reports. It updates the registry keys in HKCU:\Software\CTXCloudApi with the new details and display a test report.

.PARAMETER Color1
New Background Colour # code

.PARAMETER Color2
New foreground Colour # code

.PARAMETER LogoURL
URL to the new Logo

.EXAMPLE
Set-CTXAPI_ReportColour -Color1 '#d22c26' -Color2 '#2bb74e' -LogoURL 'https://gist.githubusercontent.com/default-monochrome.png'

#>
Function Set-CTXAPI_ReportColour {
	[Cmdletbinding(HelpURI = 'https://smitpi.github.io/CTXCloudApi/Set-CTXAPI_ReportColour')]
	[Alias('Set-CTXAPI_ReportColours')]
	PARAM(
		[string]$Color1 = '#061820',
		[string]$Color2 = '#FFD400',
		[string]$LogoURL = 'https://c.na65.content.force.com/servlet/servlet.ImageServer?id=0150h000003yYnkAAE&oid=00DE0000000c48tMAA'
	)

	Remove-Variable -Name CTXAPI_Color1, CTXAPI_Color2, CTXAPI_LogoURL -Force -ErrorAction SilentlyContinue
	$script:TableSettings = $script:SectionSettings = $script:TableSectionSettings = @{}

	Set-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name Color1 -Value $($Color1)
	Set-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name Color2 -Value $($Color2)
	Set-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name LogoURL -Value $($LogoURL)

	Start-Sleep 2

	$script:CTXAPI_Color1 = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name Color1
	$script:CTXAPI_Color2 = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name Color2
	$script:CTXAPI_LogoURL = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name LogoURL

	#region Html Settings
	$script:TableSettings = @{
		Style           = 'cell-border'
		TextWhenNoData  = 'No Data to display here'
		Buttons         = 'searchBuilder', 'pdfHtml5', 'excelHtml5'
		AutoSize        = $true
		DisableSearch   = $true
		FixedHeader     = $true
		HideFooter      = $true
		ScrollCollapse  = $true
		ScrollX         = $true
		ScrollY         = $true
		SearchHighlight = $true
	}
	$script:SectionSettings = @{
		BackgroundColor       = 'grey'
		CanCollapse           = $true
		HeaderBackGroundColor = $CTXAPI_Color1
		HeaderTextAlignment   = 'center'
		HeaderTextColor       = $CTXAPI_Color2
		HeaderTextSize        = '10'
		BorderRadius          = '15px'
	}
	$script:TableSectionSettings = @{
		BackgroundColor       = 'white'
		CanCollapse           = $true
		HeaderBackGroundColor = $CTXAPI_Color2
		HeaderTextAlignment   = 'center'
		HeaderTextColor       = $CTXAPI_Color1
		HeaderTextSize        = '10'
	}
	#endregion

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
