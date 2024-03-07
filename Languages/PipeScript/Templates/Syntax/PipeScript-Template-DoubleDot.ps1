
function Template.PipeScript.DoubleDot {
    
    <#
    .SYNOPSIS
        Supports "Double Dotted" location changes
    .DESCRIPTION
        This little compiler is here to help small syntax flubs and relative file traversal.

        Any pair of dots will be read as "Push-Location up N directories"

        `^` + Any pair of dots will be read as "Pop-Location n times"
    .EXAMPLE
        Invoke-PipeScript { .. }
    .EXAMPLE
        Invoke-PipeScript { ^.. }
    #>
    [ValidateScript({
        $commandAst = $_
        $IsOnlyDoubleDot = '^\^{0,1}(?:\.\.){1,}$'
        if (-not $commandAst.CommandElements) { return $false }
        if ($commandAst.CommandElements.Count -gt 1 )  { return $false }
        $commandAst.CommandElements[0].Value -match $IsOnlyDoubleDot
    })]
    param(
    # The command ast
    [Parameter(Mandatory,ParameterSetName='Command',ValueFromPipeline)]
    [Management.Automation.Language.CommandAst]
    $CommandAst
    )

    process {    
        [scriptblock]::Create("`$($(
            if ($CommandAst -notmatch "^\^") { # Going up!
                "Push-Location ("
                {$(if ($PSScriptRoot) { $PSScriptRoot} else { $pwd})}
                [Regex]::New("\.\.").Replace("$CommandAst", " | Split-Path")
                ")"
            } else {
                [Regex]::New("\.\.").Replace( # Going down
                    $CommandAst -replace "^\^",
                    "Pop-Location;"
                )
            }        
        )`)")
    }

}

