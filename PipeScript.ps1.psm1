[Include('*-*')]$psScriptRoot

$transpilerNames = Get-Transpiler | Select-Object -ExpandProperty DisplayName
$aliasList +=
    [SmartAlias(Command='Use-PipeScript',Prefix='.>',PassThru)]$transpilerNames

$aliasList +=
    [SmartAlias(Command='Use-PipeScript',Prefix='.<',Suffix='>',PassThru)]$transpilerNames

$MyModule = $MyInvocation.MyCommand.ScriptBlock.Module
$aliasList +=
    [GetExports("Alias")]$MyModule

Export-ModuleMember -Function * -Alias $aliasNames