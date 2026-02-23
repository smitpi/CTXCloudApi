
# if (Test-Path HKCU:\Software\CTXCloudApi) {

# 	$script:CTXAPI_Color1 = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name Color1
# 	$script:CTXAPI_Color2 = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name Color2
# 	$script:CTXAPI_LogoURL = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name LogoURL

# } else {
# 	New-Item -Path HKCU:\Software\CTXCloudApi
# 	New-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name Color1 -Value '#2b1200'
# 	New-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name Color2 -Value '#f37000'
# 	New-ItemProperty -Path HKCU:\Software\CTXCloudApi -Name LogoURL -Value 'https://www.vhv.rs/dpng/d/607-6072047_0-replies-4-retweets-5-likes-citrix-cloud.png'

# 	$script:CTXAPI_Color1 = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name Color1
# 	$script:CTXAPI_Color2 = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name Color2
# 	$script:CTXAPI_LogoURL = Get-ItemPropertyValue -Path HKCU:\Software\CTXCloudApi -Name LogoURL
# }

$script:CTXAPI_Color1 = '#2b1200'
$script:CTXAPI_Color2 = '#f37000'
#$script:CTXAPI_LogoURL = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDhA8LhyiU70Dc6v9zh5Gnb-8W05xMP2d2mw&s'
$script:CTXAPI_LogoURL = 'https://www.vhv.rs/dpng/d/607-6072047_0-replies-4-retweets-5-likes-citrix-cloud.png'
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
	HeaderTextSize        = '20'
	BorderRadius          = '25px'
}
$script:TableSectionSettings = @{
	BackgroundColor       = 'white'
	CanCollapse           = $true
	HeaderBackGroundColor = $CTXAPI_Color2
	HeaderTextAlignment   = 'center'
	HeaderTextColor       = $CTXAPI_Color1
	HeaderTextSize        = '20'
}
#endregion


