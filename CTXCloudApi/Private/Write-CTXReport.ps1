
<#PSScriptInfo

.VERSION 0.1.0

.GUID ea152572-75a0-4304-ba83-be5c1f76d426

.AUTHOR Pierre Smit

.COMPANYNAME HTPCZA Tech

.COPYRIGHT

.TAGS ctx

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [13/02/2026_10:01] Initial Script

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Script to easily create reports to excel 

#> 


<#
.SYNOPSIS
Script to easily create reports to excel

.DESCRIPTION
Script to easily create reports to excel

.EXAMPLE
Write-CTXReport -Export HTML -ReportPath C:\temp

#>
function Write-CTXReport {
	[Cmdletbinding(DefaultParameterSetName = 'Set1', HelpURI = 'https://smitpi.github.io/CTXCloudApi/Write-CTXReport')]
	[OutputType([System.Object[]])]
	#region Parameter
	param(
		[Parameter(Position = 0, Mandatory)]
		[PSCustomObject]$InputObject,
		
		[Parameter(Position = 1, Mandatory)]
		[string]$ReportTitle,

		[ValidateScript( { if (Test-Path $_) { $true }
				else { New-Item -Path $_ -ItemType Directory -Force | Out-Null; $true }
			})]
		[System.IO.DirectoryInfo]$ReportPath = 'C:\Temp'
	)
	$ExcelOptions = @{
		Path              = $(Join-Path -Path $ReportPath -ChildPath "\$($ReportTitle.Replace(' ','_'))_$(Get-Date -Format yyyy.MM.dd-HH.mm).xlsx")
		AutoSize          = $True
		AutoFilter        = $True
		TitleBold         = $True
		TitleSize         = '28'
		TitleFillPattern  = 'LightTrellis'
		TableStyle        = 'Light20'
		FreezeTopRow      = $True
		FreezePane        = '3'
		FreezeFirstColumn = $True
		MaxAutoSizeRows   = 50
	}

	$InputObject | Export-Excel -Title $ReportTitle -WorksheetName $ReportTitle @ExcelOptions 

}