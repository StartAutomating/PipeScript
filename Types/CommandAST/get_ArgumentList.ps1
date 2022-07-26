$parameterAstType  = [Management.Automation.Language.CommandParameterAst]
@(
for (
    $commandElementIndex = 1
    $commandElementIndex -lt $this.CommandElements.Count
    $commandElementIndex++
)
{
    $commandElement = $this.CommandElements[$commandElementIndex]
    $nextElement    = $this.CommandElements[$commandElementIndex + 1]
    if ($commandElement -is $parameterAstType) {
        if (-not $commandElement.Argument -and
            $nextElement -and 
            $nextElement -isnot $parameterAstType)  {
            $commandElementIndex++
        }
    } else {
        $commandElement.ConvertFromAst()  
    }    
}
)