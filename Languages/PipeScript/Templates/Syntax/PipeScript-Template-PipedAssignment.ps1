
function Template.PipeScript.PipedAssignment {

    <#
    .SYNOPSIS
        Piped Assignment Transpiler
    .DESCRIPTION
        Enables Piped Assignment (```|=|```).

        Piped Assignment allows for an expression to be reassigned based off of the pipeline input.
    .EXAMPLE
        {
            $Collection |=| Where-Object Name -match $Pattern
        } | .>PipeScript

        # This will become:

        $Collection = $Collection | Where-Object Name -match $pattern
    .EXAMPLE
        {
            $Collection |=| Where-Object Name -match $pattern | Select-Object -ExpandProperty Name
        } | .>PipeScript

        # This will become

        $Collection = $Collection |
                Where-Object Name -match $pattern |
                Select-Object -ExpandProperty Name
    #>
    [ValidateScript({
        $ast = $_
        if ($ast.PipelineElements.Count -ge 3 -and
        $ast.PipelineElements[1].CommandElements -and 
        $ast.PipelineElements[1].CommandElements[0].Value -eq '=') {
            return $true
        }
        return $false
    })]
    param(    
    [Parameter(Mandatory,ValueFromPipeline)]
    [Management.Automation.Language.PipelineAst]
    $PipelineAst
    )

    process {
        $null = $PipelineAst.PipelineElements[0]
        [ScriptBlock]::Create(@"
            $($PipelineAst.PipelineElements[0]) = $($PipelineAst.PipelineElements[0]) | $(
                $(
                    $(if ($PipelineAst.PipelineElements.Count -gt 3) {
                        [Environment]::NewLine + (' ' * 4)
                    } else {
                        ''
                    }) +        
                    (@($PipelineAst.PipelineElements[2..$PipelineAst.PipelineElements.Count]) -join (
                        ' |' + [Environment]::NewLine + (' ' * 4)
                    ))
                )
            )
"@)
    }

}

