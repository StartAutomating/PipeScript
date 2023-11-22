<#
.SYNOPSIS
    Gets a Command's Cache Control
.DESCRIPTION
    Gets a Command's Cache Control header (if present).

    Any [Reflection.AssemblyMetaData] whose key is named `*Cache*Control*` will be counted as a cache-control value.

    All values will be joined with commas and cached.
.NOTES
    Cache Control allows any script to easily specify how long it's results should be cached.
#>
if (-not $this.'.CacheControl') {
    $resolvedScriptBlock = 
        if ($this -is [Management.Automation.AliasInfo]) {
            $resolveCommand = $this
            do {
                $resolveCommand = $this.ResolvedCommand
            } while ($resolveCommand -and $resolveCommand.ResolvedCommand)
            if ($resolveCommand) {
                $resolveCommand.ScriptBlock
            }            
        } elseif ($this.ScriptBlock) {
            $this.ScriptBlock
        }

    if (-not $resolvedScriptBlock) { return }
    $cacheControlValues = foreach ($attr in $resolvedScriptBlock.Attributes) {
        if ($attr -isnot [Reflection.AssemblyMetadata]) {
            continue
        }

        if ($attr.Key -notmatch 'Cache.?Control') { continue }
        $attr.Value
    }
    Add-Member -InputObject $this -MemberType NoteProperty -Name '.CacheControl' -Value (
        $cacheControlValues  -join ','
    ) -Force
}

$This.'.CacheControl'