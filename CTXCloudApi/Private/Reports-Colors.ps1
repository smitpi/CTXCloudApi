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


