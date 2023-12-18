<#
.SYNOPSIS
    Gets PowerShell AST Nodes by type
.DESCRIPTION
    Gets a dictionary of all nodes in a PowerShell AST beneath this point, grouped by type.
.EXAMPLE
    {"hello world"}.Ast.ByType
#>
if (-not $this.'.ByType') {
    $ByType = [Collections.Generic.Dictionary[Type,Collections.Generic.List[PSObject]]]::new()
    foreach ($node in $this.FindAll({$true}, $true)) {
        $nodeType = $node.GetType()

        if (-not $ByType[$nodeType]) {
            $ByType[$nodeType] = [Collections.Generic.List[PSObject]]::new()
        }
        $ByType[$nodeType].Add($node)
    }
    Add-Member -InputObject $this -MemberType NoteProperty -Name '.ByType' -Value $ByType -Force
}

$this.'.ByType'
