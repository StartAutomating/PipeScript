$NamedParameters = [Ordered]@{}
$parameterAstType = [Management.Automation.Language.CommandParameterAst]

for (
    $commandElementIndex = 1
    $commandElementIndex -lt $this.CommandElements.Count
    $commandElementIndex++
)
{
    $commandElement = $this.CommandElements[$commandElementIndex]
    $nextElement    = $this.CommandElements[$commandElementIndex + 1]
    if ($commandElement -is $parameterAstType) {
        if ($commandElement.Argument) {            
            $NamedParameters[$commandElement.ParameterName] =                 
                $commandElement.Argument.ConvertFromAst()
        } elseif ($nextElement -and $nextElement -isnot $parameterAstType)  {
            $NamedParameters[$commandElement.ParameterName] = 
                $nextElement.Argument.ConvertFromAst()
            $commandElementIndex++
        } else {
            $NamedParameters[$commandElement.ParameterName] = $true
        }
    }
}

$NamedParameters