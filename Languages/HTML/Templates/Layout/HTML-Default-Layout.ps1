[ValidatePattern('HTML')]
param()


function Template.HTML.Default.Layout {

    <#
    .SYNOPSIS
        The default HTML layout.
    .DESCRIPTION
        The template for a default HTML layout.

        This generates a single HTML page with the provided content and metadata.

        HTML.Default.Layout -Name 'My Page' -Content 'This is my page' 
    #>
    [CmdletBinding(PositionalBinding=$false)]
    [Alias('New-WebPage','Template.default.html')]
    param(
    # The name of the page.  This will set the title tag.
    [Parameter(ValueFromPipelineByPropertyName,Position=0)]
    [Alias('Title','DisplayName')]
    [string]
    $Name,

    # The content of the page.  This is the main content of the page.
    [Parameter(ValueFromPipelineByPropertyName,Position=1)]
    [Alias('PageContent','Body')]
    [string]
    $Content,    

    # The name of the site.  If set, it will include the og:site_name meta tag.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('SiteTitle','WebsiteName')]
    [string]
    $SiteName,

    # The page type.  By default 'website'.
    # This sets the og:type meta tag.
    # Cannonically, this can be set to 'article', 'book', 'profile', 'video', 'music', 'movie', 'restaurant', 'product', 'place', 'game', 'app', 'event', or 'author'.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $PageType = 'website',
    
    # The description of the page.  If set, it will include the og:description meta tag.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Desc')]
    [string]
    $Description,

    # One or more stylesheets.  If this ends in .CSS, it will be included as a link tag.  Otherwise, it will be included as a style tag.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('CSS')]    
    [psobject[]]
    $StyleSheet,

    # One or more RSS feeds to include in the page.  If set, it will automatically include the link tag.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Feed','Feeds','RSSFeed','RSSUrl')]
    [PSObject]
    $RSS,

    # One or more Atom feeds to include in the page.  If set, it will automatically include the link tag.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('AtomFeed','AtomUrl')]
    [PSObject]
    $Atom,

    # Any JavaScripts to include in the page.  If set, it will include the script tag.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('JavaScripts','JS')]
    [psobject[]]
    $JavaScript,

    # The name of the palette to use.  If set, it will include the 4bitcss link tag.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ColorScheme','ColorPalette')]
    [string]
    $PaletteName,

    # One or more google fonts to include
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $GoogleFont,
    
    # The absolute path to the page.  If set, it will include the og:url meta tag.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('FullUrl','AbsoluteUrl','AbsoluteUri','Permalink','PermaLinkUrl','PermalinkUri')]
    [uri]
    $AbsolutePath,

    # The image to use for the page.  If set, it will include the og:image meta tag.
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Image,    

    # The language of the page.  If set, it will include the lang attribute.
    [Parameter(ValueFromPipelineByPropertyName)]
    [cultureinfo]
    $Language,

    # The date the page was published.  If set, it will include the article:published_time meta tag.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('PublishDate','Date')]
    [DateTime]
    $PublishTime,

    # The analytics ID.  If set, it will include the Google Analytics tag.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $AnalyticsID,

    # The viewport.  By default, it is set to 'width=device-width'.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Viewport = 'width=device-width',
    
    # The width of the page.  By default, it is set to '100%'.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Width = '100%',

    # The height of the page.  By default, it is set to '100%'.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Height = '100%',

    # The font size of the page.  By default, it is set to '1.5em'.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $FontSize = '1.5em',

    # The font family of the page.
    # If a -GoogleFont has been provided, this will default to the first value.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $FontFamily,

    # The page margin.  By default, nothing.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Margin,

    # The page padding. By default, nothing.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Padding,

    # Any additional header information for the page
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('PageHeader')]    
    [string]
    $Head,    
        
    # One or more CSS classes to apply to the body.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('CssClass')]
    [string[]]
    $Class
    )
    
    begin {
        filter Escape {
         [Security.SecurityElement]::Escape($_) 
        }
        filter EscapeAttribute {
         [Web.HttpUtility]::HtmlAttributeEncode($_) 
        }

        filter ToFeed {
                  
                    param([string]$FeedType)
                    if ($_ -is [string] -or $_ -is [uri]) {
                        "<link rel='alternate' type='$FeedType' title='$(@($FeedType -split '[\p{P}\+]')[1])' href='$_' />"
                    } else {
                        if ($_ -is [Collections.IDictionary]) {
                            $_ = [PSCustomObject]$_
                        }                      
                        $_ | . {
                            param(
                                [Parameter(ValueFromPipelineByPropertyName)][Alias('Title','DisplayName','FeedName','Name')][string]$FeedTitle,
                                [Parameter(ValueFromPipelineByPropertyName)][Alias('Url','Link','Feed','FeedUri')][uri]$FeedUrl
                            )
                            if (-not $FeedTitle) { $FeedTitle = $(@($FeedType -split '[\p{P}\+]')[1]) }
                            "<link rel='alternate' type='$FeedType' title='$FeedTitle' href='$FeedUrl' />"
                        }
                    }          
                
        }
    }
    
    
    process {
        $safeTitle = $Name | Escape

        $headerTags = @(
            "<title>$SafeTitle</title>"
            "<meta name='viewport' content='$Viewport' />"
            if ($SiteName) {
                "<meta content='$($SiteName | EscapeAttribute)' property='og:site_name' />"
            }
            if ($SafeTitle) { "<meta content='$SafeTitle' property='og:title' />" }
            if ($PageType) { "<meta content='$PageType' property='og:type' />" }
            if ($Description) { 
                "<meta content='$($Description | EscapeAttribute)' property='og:description' />"
                "<meta name='description' content='$($Description | EscapeAttribute)' />"
                "<meta name='twitter:description' content='$($Description | EscapeAttribute)' />"
            }
            if ($PublishTime) { "<meta content='$($PublishTime.ToString('o'))' property='article:published_time' />" }
            if ($AbsolutePath) { 
                "<meta content='$AbsolutePath' property='og:url' />"
                "<meta name='twitter:url' content='$($AbsolutePath | EscapeAttribute)' />"
                if ($AbsolutePath.DnsSafeHost) {
                    "<meta name='twitter:domain' content='$($AbsolutePath.DnsSafeHost | EscapeAttribute)' />"              
                }
            }
            if ($Image) {
                "<meta content='$Image' property='og:image' />"
                "<meta name='twitter:image' content='$($Image | EscapeAttribute)' />"
                "<meta name='twitter:image:src' content='$($Image | EscapeAttribute)' />"
            }

            if ($AnalyticsID) {
                "<!-- Google tag (gtag.js) -->"
                '<script async src="https://www.googletagmanager.com/gtag/js?id={{site.analyticsID}}"></script>'
                "<script>window.dataLayer = window.dataLayer || [];function gtag(){dataLayer.push(arguments);};gtag('js', new Date());gtag('config', '$analyticsID');</script>"              
            }
            if ($GoogleFont) {
                "<link href='https://fonts.googleapis.com/css?family=$($GoogleFont -join '|')' rel='stylesheet'>"
                if (-not $PSBoundParameters['FontFamily']) { $FontFamily = $GoogleFont[0] }
            }
            if ($PaletteName) {
                foreach ($NameOfPalette in $PaletteName) {
                    $MachineFriendlyName = $NameOfPalette -replace '\s','-' -replace '\p{P}','-' -replace '-+','-' -replace '-$'
                    "<link rel='stylesheet' type='text/css' href='https://cdn.jsdelivr.net/gh/2bitdesigns/4bitcss@latest/css/$MachineFriendlyName.css' id='4bitcss' />"              
                }
                $Class += "foreground", "background"
            }

            if ($RSS) {
                $RSS | ToFeed -FeedType 'application/rss+xml'
            }

            if ($Atom) {
                $Atom | ToFeed -FeedType 'application/atom+xml'
            }
                    
            foreach ($css in $StyleSheet) {
                if ($css -match '\.css$') {
                    "<link rel='stylesheet' type='text/css' href='$css' />"
                } else {
                    "<style>$css</style>"
                }              
            }

            $defaultBodyStyle = @(
                if ($Width) { "width: $Width" }
                if ($Height) { "height: $Height" }
                if ($FontSize) { "font-size: $FontSize" }              
                if ($FontFamily) { "font-family: $FontFamily" }
                if ($Margin) { "margin: $Margin" }
                if ($Padding) { "padding: $Padding" }
            ) -join ';'

            if ($defaultBodyStyle) {
                "<style>body { $defaultBodyStyle }</style>"
            }

            foreach ($js in $JavaScript) {
                if ($js -notmatch '\n' -and $js -match '\.js$') {
                    "<script type='text/javascript' src='$js'></script>"
                }
                elseif ($js -notmatch '^\s{0,}<script') {
                    "<script type='text/javascript'>$js</script>"
                }
                else {
                    $js
                }
            }

            if ($Head) {              
                $Head              
            }
      )  -join ([Environment]::newLine + (' ' * 4))


@"
<!DOCTYPE html>
<html lang="$($Language.TwoLetterISOLanguageName)">
  <head>
    $headerTags
  </head>      
  <body$(if ($Class) { " class='$($class -join ' ')'"})>
  $content    
  </body>
</html>
"@
        }

}



