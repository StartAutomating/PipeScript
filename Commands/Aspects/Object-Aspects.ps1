[ValidatePattern("Object")]
param()


function Aspect.GroupObjectByTypeName {

    <#
    .SYNOPSIS
        Groups objects by type name
    .DESCRIPTION
        Groups objects by the first of their `.pstypenames`
    .EXAMPLE
        Get-ChildItem | Aspect.GroupByTypeName
    #>
    [Alias('Aspect.GroupByTypeName')]
    param(<# One or More InputObjects #>[Parameter(ValueFromPipeline)][PSObject[]]$InputObject)

    begin {$groupedByTypeName = [Ordered]@{}}
    process {
        foreach ($inObj in $InputObject) {
            $pstypeName = $inObj.pstypenames[0]
            if (-not $groupedByTypeName[$pstypeName]) {
                $groupedByTypeName[$pstypeName] = [Collections.Generic.List[PSObject]]::new()
            }
            $groupedByTypeName[$pstypeName].Add($inObj)
        }
    }
    end {$groupedByTypeName}        

}




function Aspect.GroupObjectByType {

    <#
    .SYNOPSIS
        Groups objects by types
    .DESCRIPTION
        Groups objects by objects by their .NET type
    .EXAMPLE
        Get-ChildItem | Aspect.GroupByType
    #>
    [Alias('Aspect.GroupByType')]
    param(<# One or More Input Objects #>[Parameter(ValueFromPipeline)][PSObject[]]$InputObject)

    begin {$groupedByType = [Ordered]@{}}
    process {
        foreach ($inObj in $InputObject) {
            $dotNetType = $inObj.GetType()
            if (-not $groupedByType[$dotNetType]) {
                $groupedByType[$dotNetType] = [Collections.Generic.List[PSObject]]::new()
            }
            $groupedByType[$dotNetType].Add($inObj)
        }
    }
    end {
        $groupedByType
    }        

}

