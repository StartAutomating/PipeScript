<#
.SYNOPSIS
    On / When keyword
.DESCRIPTION
    The On / When keyword makes it easier to subscribe to events in PowerShell and PipeScript 
.EXAMPLE
    Use-PipeScript {
        $y = when x {
            "y"
        }
    }

    Use-PipeScript {
        $timer = new Timers.Timer 1000 @{AutoReset=$false}
        when $timer.Elapsed {
            "time's up"
        }
    }
#>
[ValidateScript({
    $CommandAst = $_
    $CommandAst.CommandElements -and 
    $CommandAst.CommandElements[0].Value -in 'when', 'on'
})]
[Reflection.AssemblyMetadata("PipeScript.Keyword",$true)]
param(
[Parameter(Mandatory,ValueFromPipeline)]
[Management.Automation.Language.CommandAST]
$CommandAst
)

begin {
    filter =>[StringConstantExpressionAst]=>[ScriptBlock] {
        if ($_ -isnot [Management.Automation.Language.StringConstantExpressionAst]) { return $_ }
        [ScriptBlock]::Create("`$when = Register-EngineEvent $_ $($args -join ' ')")
    }
    filter =>[MemberExpressionAst]=>[ScriptBlock] {
        if ($_ -isnot [Management.Automation.Language.MemberExpressionAst]) { return $_ }
        [ScriptBlock]::Create("`$when = Register-ObjectEvent -InputObject $($_.Expression) -EventName $($_.Member) $($args -join ' ')")
    }    
    filter =>[ArrayLiteralAst]=>[ScriptBlock] {
        if ($_ -isnot [Management.Automation.Language.ArrayLiteralAst]) { return $_ }
        [ScriptBlock]::Create("`$when = @($(
                @($_.elements |
                    =[StringConstantExpressionAst]=>[ScriptBlock] @args|
                    =[MemberExpressionAst]=>[ScriptBlock] @args
                ) -replace '\$when\s=\s' -join [Environment]::NewLine
))")
    }
    
    filter =>Process[ScriptBlock]IfPipedTo {
        $in = $_
        if ($args -and $args.IsPipedTo) {
            [scriptblock]::Create(". { process { $_ } }")
        } else {
            $_
        }
    }

    filter =>PassThru[ScriptBlock]WhenIfNotAssignedOrPipedFrom {
        if ($args -and ($args.IsAssigned -or $args.IsPipedFrom)) {
            [scriptblock]::Create($_ -replace '\$when\s=\s')
        } else {
            $_
        }
    }
}
process {
    $whenKeyword, $firstElement, $restOfElements = $CommandAst.CommandElements    
    $restOfElements = @($restOfElements)
    $firstElement | 
        =>[StringConstantExpressionAst]=>[ScriptBlock] @restOfElements |
        =>[MemberExpressionAst]=>[ScriptBlock] @restOfElements |
        =>[ArrayLiteralAst]=>[ScriptBlock] @restOfElements |
        =>PassThru[ScriptBlock]WhenIfNotAssignedOrPipedFrom $CommandAst |
        =>Process[ScriptBlock]IfPipedTo $CommandAst
        
}
