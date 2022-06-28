<#
.SYNOPSIS
    C# Inline PipeScript Transpiler.
.DESCRIPTION
    Transpiles C# with Inline PipeScript into C#.

    Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

    Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

    This for Inline PipeScript to be used with operators, and still be valid C# syntax. 

    The C# Inline Transpiler will consider the following syntax to be empty:

    * ```String.Empty```
    * ```null```
    * ```""```
    * ```''```
.EXAMPLE
    .> {
        $CSharpLiteral = @'
namespace TestProgram/*{Get-Random}*/ {
    public static class Program {
        public static void Main(string[] args) {
            string helloMessage = /*{
                '"hello"', '"hello world"', '"hey there"', '"howdy"' | Get-Random
            }*/ string.Empty; 
            System.Console.WriteLine(helloMessage);
        }
    }
}    
'@

        [OutputFile(".\HelloWorld.ps1.cs")]$CSharpLiteral
    }

    $AddedFile = .> .\HelloWorld.ps1.cs
    $addedType = Add-Type -TypeDefinition (Get-Content $addedFile.FullName -Raw) -PassThru
    $addedType::Main(@())
.EXAMPLE
    // HelloWorld.ps1.cs
    namespace TestProgram {
        public static class Program {
            public static void Main(string[] args) {
                string helloMessage = /*{
                    '"hello"', '"hello world"', '"hey there"', '"howdy"' | Get-Random
                }*/ string.Empty; 
                System.Console.WriteLine(helloMessage);
            }
        }
    }
#>
[ValidateScript({
    $cmdInfo = $_
    if ($cmdInfo.Source -match '\.cs$') {
        return $true
    }
    return $false    
})]
param(
# The command information.  This will include the path to the file.
[Parameter(Mandatory,ValueFromPipeline)]
$CommandInfo
)

begin {
    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext ```String.empty```, ```null```, blank strings and characters
    $IgnoredContext = "(?<ignore>(?>$("String\.empty", "null", '""', "''" -join '|'))\s{0,}){0,1}"
    # * StartRegex     ```$IgnoredContext + $StartComment + '{' + $Whitespace```
    $startRegex = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment + $ignoredContext```
    $endRegex   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"


    $ReplacablePattern = [Regex]::New("
    # Match the PipeScript Start
    $startRegex
    # Match until the PipeScript end.  This will be PipeScript
    (?<PipeScript>
    (?:.|\s){0,}?(?=\z|$endRegex)
    )
    # Then Match the PipeScript End
    $endRegex
        ", 'IgnoreCase, IgnorePatternWhitespace', '00:00:10')
}

process {
    
    $fileInfo = $commandInfo.Source -as [IO.FileInfo]
    $fileText      = [IO.File]::ReadAllText($fileInfo.Fullname)

    .>PipeScript.Inline -SourceFile $CommandInfo.Source -SourceText $fileText -ReplacePattern $ReplacablePattern    
}
