Template.HTML.Default.Layout
----------------------------

### Synopsis
The default HTML layout.

---

### Description

The template for a default HTML layout.

This generates a single HTML page with the provided content and metadata.

HTML.Default.Layout -Name 'My Page' -Content 'This is my page'

---

### Parameters
#### **Name**
The name of the page.  This will set the title tag.

|Type      |Required|Position|PipelineInput        |Aliases              |
|----------|--------|--------|---------------------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|Title<br/>DisplayName|

#### **Content**
The content of the page.  This is the main content of the page.

|Type      |Required|Position|PipelineInput        |Aliases             |
|----------|--------|--------|---------------------|--------------------|
|`[String]`|false   |2       |true (ByPropertyName)|PageContent<br/>Body|

#### **SiteName**
The name of the site.  If set, it will include the og:site_name meta tag.

|Type      |Required|Position|PipelineInput        |Aliases                  |
|----------|--------|--------|---------------------|-------------------------|
|`[String]`|false   |named   |true (ByPropertyName)|SiteTitle<br/>WebsiteName|

#### **PageType**
The page type.  By default 'website'.
This sets the og:type meta tag.
Cannonically, this can be set to 'article', 'book', 'profile', 'video', 'music', 'movie', 'restaurant', 'product', 'place', 'game', 'app', 'event', or 'author'.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Description**
The description of the page.  If set, it will include the og:description meta tag.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |named   |true (ByPropertyName)|Desc   |

#### **StyleSheet**
One or more stylesheets.  If this ends in .CSS, it will be included as a link tag.  Otherwise, it will be included as a style tag.

|Type        |Required|Position|PipelineInput        |Aliases|
|------------|--------|--------|---------------------|-------|
|`[String[]]`|false   |named   |true (ByPropertyName)|CSS    |

#### **RSS**
One or more RSS feeds to include in the page.  If set, it will automatically include the link tag.

|Type        |Required|Position|PipelineInput        |Aliases                              |
|------------|--------|--------|---------------------|-------------------------------------|
|`[PSObject]`|false   |named   |true (ByPropertyName)|Feed<br/>Feeds<br/>RSSFeed<br/>RSSUrl|

#### **Atom**
One or more Atom feeds to include in the page.  If set, it will automatically include the link tag.

|Type        |Required|Position|PipelineInput        |Aliases             |
|------------|--------|--------|---------------------|--------------------|
|`[PSObject]`|false   |named   |true (ByPropertyName)|AtomFeed<br/>AtomUrl|

#### **JavaScript**
Any JavaScripts to include in the page.  If set, it will include the script tag.

|Type     |Required|Position|PipelineInput        |Aliases           |
|---------|--------|--------|---------------------|------------------|
|`[Uri[]]`|false   |named   |true (ByPropertyName)|JavaScripts<br/>JS|

#### **PaletteName**
The name of the palette to use.  If set, it will include the 4bitcss link tag.

|Type      |Required|Position|PipelineInput        |Aliases                     |
|----------|--------|--------|---------------------|----------------------------|
|`[String]`|false   |named   |true (ByPropertyName)|ColorScheme<br/>ColorPalette|

#### **GoogleFont**
One or more google fonts to include

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|

#### **AbsolutePath**
The absolute path to the page.  If set, it will include the og:url meta tag.

|Type   |Required|Position|PipelineInput        |Aliases                                                                                |
|-------|--------|--------|---------------------|---------------------------------------------------------------------------------------|
|`[Uri]`|false   |named   |true (ByPropertyName)|FullUrl<br/>AbsoluteUrl<br/>AbsoluteUri<br/>Permalink<br/>PermaLinkUrl<br/>PermalinkUri|

#### **Image**
The image to use for the page.  If set, it will include the og:image meta tag.

|Type   |Required|Position|PipelineInput        |
|-------|--------|--------|---------------------|
|`[Uri]`|false   |named   |true (ByPropertyName)|

#### **Language**
The language of the page.  If set, it will include the lang attribute.

|Type           |Required|Position|PipelineInput        |
|---------------|--------|--------|---------------------|
|`[CultureInfo]`|false   |named   |true (ByPropertyName)|

#### **PublishTime**
The date the page was published.  If set, it will include the article:published_time meta tag.

|Type        |Required|Position|PipelineInput        |Aliases             |
|------------|--------|--------|---------------------|--------------------|
|`[DateTime]`|false   |named   |true (ByPropertyName)|PublishDate<br/>Date|

#### **AnalyticsID**
The analytics ID.  If set, it will include the Google Analytics tag.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Viewport**
The viewport.  By default, it is set to 'width=device-width'.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Width**
The width of the page.  By default, it is set to '100%'.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Height**
The height of the page.  By default, it is set to '100%'.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **FontSize**
The font size of the page.  By default, it is set to '1.5em'.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **FontFamily**
The font family of the page.
If a -GoogleFont has been provided, this will default to the first value.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Margin**
The page margin.  By default, nothing.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Padding**
The page padding. By default, nothing.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Head**
Any additional header information for the page

|Type      |Required|Position|PipelineInput        |Aliases   |
|----------|--------|--------|---------------------|----------|
|`[String]`|false   |named   |true (ByPropertyName)|PageHeader|

#### **Class**
One or more CSS classes to apply to the body.

|Type        |Required|Position|PipelineInput        |Aliases |
|------------|--------|--------|---------------------|--------|
|`[String[]]`|false   |named   |true (ByPropertyName)|CssClass|

---

### Syntax
```PowerShell
Template.HTML.Default.Layout [[-Name] <String>] [[-Content] <String>] [-SiteName <String>] [-PageType <String>] [-Description <String>] [-StyleSheet <String[]>] [-RSS <PSObject>] [-Atom <PSObject>] [-JavaScript <Uri[]>] [-PaletteName <String>] [-GoogleFont <String[]>] [-AbsolutePath <Uri>] [-Image <Uri>] [-Language <CultureInfo>] [-PublishTime <DateTime>] [-AnalyticsID <String>] [-Viewport <String>] [-Width <String>] [-Height <String>] [-FontSize <String>] [-FontFamily <String>] [-Margin <String>] [-Padding <String>] [-Head <String>] [-Class <String[]>] [<CommonParameters>]
```
