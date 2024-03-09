<#
.SYNOPSIS
    Gets Module EntryPoints
.DESCRIPTION
    Gets any EntryPoints associated with a module.

    EntryPoints describe the command that should be run when the module is launched (ideally in a container).

    EntryPoints can be defined within a module's `.PrivateData` or `.PrivateData.PSData`
#>
param()

$ThisRoot = $this | Split-Path
$theModule = $this

$moduleDefinedEntryPoints = @(foreach ($place in $this.PrivateData, $this.PrivateData.PSData) {
    foreach ($potentialName in 'EntryPoint', 'EntryPoints') {
        $potentialEntryPoints = $place.$potentialName
        if (-not $potentialEntryPoints) { continue }

        foreach ($potentialEntryPoint in $potentialEntryPoints) {
            $potentialEntryPoint = 
                if ($potentialEntryPoint -is [hashtable]) {                
                    $EntryPointObject = [Ordered]@{}
                    foreach ($sortedKeyValue in $place.$potentialName.GetEnumerator() | Sort-Object Key) {
                        $EntryPointObject[$sortedKeyValue.Key]= $sortedKeyValue.Value
                    }
                    $EntryPointObject = [PSCustomObject]$EntryPointObject                    
                } 
                elseif (Test-Path (Join-Path $ThisRoot $potentialEntryPoint)) {
                    [PSObject]::new((Get-Item -LiteralPath (Join-Path $ThisRoot $potentialEntryPoint)))
                }
                elseif ($potentialEntryPoint) {                    
                    [PSObject]::new($potentialEntryPoint)
                }
            $potentialEntryPoint.pstypenames.clear()
            $potentialEntryPoint.pstypenames.add("$this.EntryPoint")
            $potentialEntryPoint.pstypenames.add('PipeScript.Module.EntryPoint')
            Add-Member -InputObject $potentialEntryPoint -Name Module -Value $this -Force -MemberType NoteProperty
            $potentialEntryPoint
        }
    }
})


return $moduleDefinedEntryPoints
