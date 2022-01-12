
if (Test-Path HKCU:\Software\CTXCloudApi) {

    $global:CTXAPI_Color1 = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name Color1
    $global:CTXAPI_Color2 = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name Color2
    $global:CTXAPI_LogoURL = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name LogoURL

}
else {
        New-Item -Path HKCU:\Software\CTXCloudApi
        New-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name Color1 -Value '#061820'
        New-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name Color2 -Value '#FFD400'
        New-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name LogoURL -Value 'https://c.na65.content.force.com/servlet/servlet.ImageServer?id=0150h000003yYnkAAE&oid=00DE0000000c48tMAA'

    $global:CTXAPI_Color1 = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name Color1
    $global:CTXAPI_Color2 = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name Color2
    $global:CTXAPI_LogoURL = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name LogoURL
}


#region Html Settings
$global:TableSettings = @{
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
$global:SectionSettings = @{
	BackgroundColor       = 'grey'
	CanCollapse           = $true
	HeaderBackGroundColor = $CTXAPI_Color1
	HeaderTextAlignment   = 'center'
	HeaderTextColor       = $CTXAPI_Color2
	HeaderTextSize        = '10'
	BorderRadius          = '15px'
}
$global:TableSectionSettings = @{
	BackgroundColor       = 'white'
	CanCollapse           = $true
	HeaderBackGroundColor = $CTXAPI_Color2
	HeaderTextAlignment   = 'center'
	HeaderTextColor       = $CTXAPI_Color1
	HeaderTextSize        = '10'
}
#endregion


