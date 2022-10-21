[Include('*-*')]$psScriptRoot

$transpilerNames = Get-Transpiler | Select-Object -ExpandProperty DisplayName
$aliasList +=
    [SmartAlias(Command='Use-PipeScript',Prefix='.>',PassThru)]$transpilerNames

$aliasList +=
    [SmartAlias(Command='Use-PipeScript',Prefix='.<',Suffix='>',PassThru)]$transpilerNames

$pipeScriptKeywords =
    Get-Transpiler |
    Where-Object { $_.Metadata.'PipeScript.Keyword' }  |
    Select-Object -ExpandProperty DisplayName

$aliasList +=
    [SmartAlias(Command='Use-PipeScript',PassThru)]$pipeScriptKeywords

$MyModule = $MyInvocation.MyCommand.ScriptBlock.Module
$aliasList +=
    [GetExports("Alias")]$MyModule

Export-ModuleMember -Function * -Alias $aliasList