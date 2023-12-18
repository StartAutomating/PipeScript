<#
.SYNOPSIS
    Finds all CSharp Nodes
.DESCRIPTION
    Finds all CSharp Syntax Nodes that meet any one of a number of criteria
.EXAMPLE
    (Parse-CSharp 'Console.WriteLine("Hello World");').FindAll("*hello*")
#>
param()

$Conditions = @(
foreach ($argument in $args) {
    if ($argument -is [scriptblock]) {
        [ScriptBlock]::Create($argument)
    }
    elseif ($argument -is [string]) {
        [ScriptBlock]::Create("$_ -like $argument")
    }
}
)

foreach ($node in $this.DescendantNodes($null, $true)) {
    foreach ($condition in $Conditions) {
        $_ = $ast = $node
        $conditionResult = . $condition
        if ($conditionResult) {
            $node
        }
    }    
}



