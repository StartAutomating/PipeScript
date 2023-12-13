<#
.SYNOPSIS
    Gets the parser for a command.
.DESCRIPTION
    Gets the parser for a given command.
#>
param(
# The command line to examine for a match.
[Alias('InvocationName')]
[string]
$CommandLine
)


foreach ($parserCommand in $this.All) {
    if ($parserCommand -is [Management.Automation.AliasInfo]) {
        $resolvedParserCommand = $parserCommand
        while ($resolvedParserCommand.ResolvedCommand) {
            $resolvedParserCommand = $resolvedParserCommand.ResolvedCommand
        }
        if ($resolvedParserCommand.ScriptBlock) {
            $parserCommand = $resolvedParserCommand
        }
    }
    if (-not $parserCommand.ScriptBlock) { continue }
    foreach ($parserAttribute in $parserCommand.ScriptBlock.Attributes) {
        if ($parserAttribute -isnot [ValidatePattern]) { continue }
        
        $pattern = [Regex]::new($parserAttribute.RegexPattern, $parserAttribute.Options, '00:00:01')
        if ($pattern.IsMatch($CommandName)) {
            $parserCommand
            break
        }
    }
}