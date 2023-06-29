<#
.SYNOPSIS
    Gets Block Comments
.DESCRIPTION
    Gets Block Comments declared within a script.
#>
$TargetScriptBlock = $this.ScriptBlock
if (-not $TargetScriptBlock) {
    if ($this -is [Management.Automation.AliasInfo]) {
        $resolveThis = $this
        while ($resolveThis.ResolvedCommand) {
            $resolveThis = $resolveThis.ResolvedCommand
        }
        if ($resolveThis.ScriptBlock) {
            $TargetScriptBlock = $resolveThis.ScriptBlock
        } else {
            $TargetScriptBlock = ''
        }
    } else {
        $TargetScriptBlock = ''
    }    
}

@([Regex]::New("
\<\# # The opening tag
(?<Block>
    (?:.|\s)+?(?=\z|\#>) # anything until the closing tag
)
\#\> # the closing tag
", 'IgnoreCase,IgnorePatternWhitespace', '00:00:01').Matches($TargetScriptBlock)) -as [Text.RegularExpressions.Match[]]
