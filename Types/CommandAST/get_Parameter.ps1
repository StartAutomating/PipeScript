$commandAst = $this
$NamedParameters = [Ordered]@{}
$parameterAstType = [Management.Automation.Language.CommandParameterAst]

for (
    $commandElementIndex = 1
    $commandElementIndex -lt $commandAst.CommandElements.Count
    $commandElementIndex++
)
{
    $commandElement = $commandAst.CommandElements[$commandElementIndex]
    $nextElement    = $commandAst.CommandElements[$commandElementIndex + 1]
    if ($commandElement -is $parameterAstType) {
        if ($commandElement.Argument) {            
            $NamedParameters[$commandElement.ParameterName] =                 
                $commandElement.Argument.ConvertFromAst()
        } elseif ($nextElement -and $nextElement -isnot $parameterAstType)  {
            $NamedParameters[$commandElement.ParameterName] = 
                $nextElement.ConvertFromAst()
            $commandElementIndex++
        } else {
            $NamedParameters[$commandElement.ParameterName] = $true
        }
    }
}

$NamedParameters