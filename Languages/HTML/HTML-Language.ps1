
function Language.HTML {
<#
.SYNOPSIS
    HTML PipeScript Transpiler.
.DESCRIPTION
    Allows PipeScript to generate HTML.

    Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.

    JavaScript/CSS comment blocks like ```/*{}*/``` will also be treated as blocks of PipeScript.
.Example
    .> {
        $HtmlWithInlinePipeScript = @'
<html>
    <head>        
        <title>
            Joke of the Day
        </title>
        <style>
            .Joke {
                font-size: 1.5em;
                width: 100%;
            }
            .JokeSetup {
                font-size: 1.1em;
                text-align: center;
            }
            .JokePunchLine {
                font-size: 1.25em;
                text-align: center;
            }
            .Datestamp {
                position:fixed;
                bottom: 0;
                left: 0;                
            }
        </style>
    </head>
    <body>
        <!--{
            "<div class='Joke'>" + $(
                Invoke-RestMethod -Uri 'https://v2.jokeapi.dev/joke/Any' | 
                    Foreach-Object {
                        if ($_.Joke) { $_.Joke}
                        elseif ($_.Setup -and $_.Delivery) {
                            "<div class='JokeSetup'>" + $_.Setup + "</div>"
                            "<div class='JokePunchline'>" + $_.Delivery + "</div>"
                        }
                    }
            ) + "</div>"

            "<div class='Datestamp'>" + 
                "Last Updated:" +
                (Get-Date | Out-String) +
                "</div>"
        }-->
    </body>
</html>

'@

        [OutputFile(".\Index.ps.html")]$HtmlWithInlinePipeScript
    }

    $htmlFile = .> .\Index.ps.html
#>
[ValidatePattern('\.htm{0,1}')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param(
)
    $FilePattern = '\.htm{0,1}'

    # We start off by declaring a number of regular expressions:
    $startComment = '(?><\!--|/\*)' # * Start Comments ```<!--```
    $endComment   = '(?>-->|\*/)'   # * End Comments   ```-->```
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartRegex     ```$StartComment + '{' + $Whitespace```
    $StartPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment```
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"
    $LanguageName = 'HTML'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.HTML")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}

