<#
.SYNOPSIS
    Gets Extensions for a name.
.DESCRIPTION
    Gets Extensions for an invocation name.
.EXAMPLE
    (Get-Module PipeScript).ExtensionsForName(".cs")
#>
param(
[string]
$InvocationName
)

@(:nextExtension foreach ($extension in $this.Extension) {
    foreach ($attr in $extension.ScriptBlock.Attributes) {
        if ($attr -isnot [ValidatePattern]) { continue }
        $validatePattern = [regex]::new(
            $attr.RegexPattern,
            $attr.Options,
            [Timespan]'00:00:00.1'
        )
        if ($validatePattern.IsMatch($InvocationName)) {
            $extension
            continue nextExtension
        }
    }    
})