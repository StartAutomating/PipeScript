<#
.SYNOPSIS
    Finds a CSharp Node
.DESCRIPTION
    Finds a single CSharp Syntax Node that meets any one of a number of criteria
.EXAMPLE
    (Parse-CSharp 'Console.WriteLine("Hello World");').Find("*hello*")
#>
param()

$Conditions = @(
foreach ($argument in $args) {
    if ($argument -is [scriptblock]) {
        [ScriptBlock]::Create($argument)
    }
    elseif ($argument -is [string]) {
        [ScriptBlock]::Create("`$_ -like '$argument'")
    }
    elseif ($argument -is [type] -and $argument.IsPublic) {
        [ScriptBlock]::Create("`$_ -as [$($argument.Fullname)]")   
    }
}
)

foreach ($node in $this.DescendantNodes($null, $true)) {
    foreach ($condition in $Conditions) {
        $_ = $ast = $node
        $conditionResult = . $condition
        if ($conditionResult) {
            return $node
        }
    }    
}



