
describe 'Language.HTML' {
    it 'Language.HTML Example 1' {
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
    }
}

