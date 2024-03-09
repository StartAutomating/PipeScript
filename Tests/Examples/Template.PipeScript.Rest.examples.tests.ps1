
describe 'Template.PipeScript.Rest' {
    it 'Template.PipeScript.Rest Example 1' {
        {
            function Get-Sentiment {
                [Rest("http://text-processing.com/api/sentiment/",
                    ContentType="application/x-www-form-urlencoded",
                    Method = "POST",
                    BodyParameter="Text",
                    ForeachOutput = {
                        $_ | Select-Object -ExpandProperty Probability -Property Label
                    }
                )]
                param()
            } 
        } | .>PipeScript | Set-Content .\Get-Sentiment.ps1
    }
    it 'Template.PipeScript.Rest Example 2' {
        Invoke-PipeScript {
            [Rest("http://text-processing.com/api/sentiment/",
                ContentType="application/x-www-form-urlencoded",
                Method = "POST",
                BodyParameter="Text",
                ForeachOutput = {
                    $_ | Select-Object -ExpandProperty Probability -Property Label
                }
            )]
            param()
        } -Parameter @{Text='wow!'}
    }
    it 'Template.PipeScript.Rest Example 3' {
        {
            [Rest("https://api.github.com/users/{username}/repos",
                QueryParameter={"type", "sort", "direction", "page", "per_page"}
            )]
            param()
        } | .>PipeScript
    }
    it 'Template.PipeScript.Rest Example 4' {
        Invoke-PipeScript {
            [Rest("https://api.github.com/users/{username}/repos",
                QueryParameter={"type", "sort", "direction", "page", "per_page"}
            )]
            param()
        } -UserName StartAutomating
    }
    it 'Template.PipeScript.Rest Example 5' {
        {
            [Rest("http://text-processing.com/api/sentiment/",
                ContentType="application/x-www-form-urlencoded",
                Method = "POST",
                BodyParameter={@{
                    Text = '
                        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
                        [string]
                        $Text
                    '
                }})]
            param()
        } | .>PipeScript
    }
}

