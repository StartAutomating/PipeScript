
function Language.CSharp {
<#
    .SYNOPSIS
        C# Language Definition.
    .DESCRIPTION
        Allows PipeScript to Generate C#.
        Multiline comments with /*{}*/ will be treated as blocks of PipeScript.
        Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.
        The C# Inline Transpiler will consider the following syntax to be empty:
        * ```String.Empty```
        * ```null```
        * ```""```
        * ```''```
    .EXAMPLE
        .> {
            $CSharpLiteral = '
    namespace TestProgram/*{Get-Random}*/ {
        public static class Program {
            public static void Main(string[] args) {
                string helloMessage = /*{
                    ''"hello"'', ''"hello world"'', ''"hey there"'', ''"howdy"'' | Get-Random
                }*/ string.Empty; 
                System.Console.WriteLine(helloMessage);
            }
        }
    }    
    '
            [OutputFile(".\HelloWorld.ps1.cs")]$CSharpLiteral
        }
        $AddedFile = .> .\HelloWorld.ps1.cs
        $addedType = Add-Type -TypeDefinition (Get-Content $addedFile.FullName -Raw) -PassThru
        $addedType::Main(@())    
    #>
[ValidatePattern('\.cs$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'CSharp'
    $startComment = '/\*'
$endComment   = '\*/'
$Whitespace   = '[\s\n\r]{0,}'
$IgnoredContext = "(?<ignore>(?>$("String\.empty", "null", '""', "''" -join '|'))\s{0,}){0,1}"
$StartPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
$EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"
$Compiler = @($ExecutionContext.SessionState.InvokeCommand.GetCommand('dotnet', 'Application'))[0], 'build'
$Runner  = @($ExecutionContext.SessionState.InvokeCommand.GetCommand('dotnet', 'Application'))[0], 'run'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.CSharp")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}



