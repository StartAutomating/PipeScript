<#
.SYNOPSIS
    Gets Module Containers
.DESCRIPTION
    Gets any containers associated with a module.

    Containers describe the environment in which a module is intended to run.
    
    They act as a bridge between the module and the Docker ecosystem.

    Containers can be defined within a module's `.PrivateData` or `.PrivateData.PSData`
#>
param()

$ThisRoot = $this | Split-Path
$theModule = $this

$moduleDefinedContainers = @(foreach ($place in $this.PrivateData, $this.PrivateData.PSData) {
    foreach ($potentialName in 'Container', 'Containers','Docker','Rocker','DevContainer','DevContainers') {
        $potentialContainers = $place.$potentialName
        if (-not $potentialContainers) { continue }

        foreach ($potentialContainer in $potentialContainers) {
            $potentialContainer = 
                if ($potentialContainer -is [hashtable]) {                
                    $ContainerObject = [Ordered]@{}
                    foreach ($sortedKeyValue in $place.$potentialName.GetEnumerator() | Sort-Object Key) {
                        $ContainerObject[$sortedKeyValue.Key]= $sortedKeyValue.Value
                    }
                    $ContainerObject = [PSCustomObject]$ContainerObject                    
                } 
                elseif (Test-Path (Join-Path $ThisRoot $potentialContainer)) {
                    [PSObject]::new((Get-Item -LiteralPath (Join-Path $ThisRoot $potentialContainer)))
                }
                elseif ($potentialContainer) {                    
                    [PSObject]::new($potentialContainer)
                }
            $potentialContainer.pstypenames.clear()
            $potentialContainer.pstypenames.add("$this.Container")
            $potentialContainer.pstypenames.add('PipeScript.Module.Container')
            Add-Member -InputObject $potentialContainer -Name Module -Value $this -Force -MemberType NoteProperty
            $potentialContainer
        }
    }
})

if ($moduleDefinedContainers) {
    $moduleDefinedContainers
} else {
    [PSCustomObject][Ordered]@{
        PSTypeName = 'PipeScript.Module.Container'
        Module = $this
    }
   
}