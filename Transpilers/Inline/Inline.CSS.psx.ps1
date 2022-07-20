<#
.SYNOPSIS
    CSS Inline PipeScript Transpiler.
.DESCRIPTION
    Transpiles CSS with Inline PipeScript into CSS.

    Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

    Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

    This for Inline PipeScript to be used with operators, and still be valid CSS syntax. 

    The CSS Inline Transpiler will consider the following syntax to be empty:

    * ```(?<q>["'])\#[a-f0-9]{3}(\k<q>)```
    * ```\#[a-f0-9]{6}```
    * ```[\d\.](?>pt|px|em)```
    * ```auto```
.EXAMPLE
    .> {
        $StyleSheet = @'
MyClass {
    text-color: "#000000" /*{
"'red'", "'green'","'blue'" | Get-Random
    }*/;
}
'@
        [Save(".\StyleSheet.ps1.css")]$StyleSheet
    }

    .> .\StyleSheet.ps1.css
#>
[ValidateScript({
    $cmdInfo = $_
    if ($cmdInfo.Source -match '\.s{0,1}css$') {
        return $true
    }
    return $false    
})]
param(
# The command information.  This will include the path to the file.
[Parameter(Mandatory,ValueFromPipeline)]
$CommandInfo,

# A dictionary of parameters.
[Collections.IDictionary]
$Parameter,

# A list of arguments.
[PSObject[]]
$ArgumentList
)

begin {
    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    $ignoreEach = '[''"]{0,1}\#[a-f0-9]{6}[''"]{0,1}', 
        '[''"]{0,1}\#[a-f0-9]{3}[''"]{0,1}',
        '[\d\.]+(?>em|pt|px){0,1}',
        'auto',
        "''"

    $IgnoredContext = "(?<ignore>(?>$($ignoreEach -join '|'))\s{0,}){0,1}"
    # * StartRegex     ```$IgnoredContext + $StartComment + '{' + $Whitespace```
    $startRegex = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment + $ignoredContext```
    $endRegex   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"
    
    # Create a splat containing arguments to the core inline transpiler
    $Splat      = [Ordered]@{
        StartPattern  = $startRegex
        EndPattern    = $endRegex
    }
}

process {
    # Add parameters related to the file
    $Splat.SourceFile = $commandInfo.Source -as [IO.FileInfo]
    $Splat.SourceText = [IO.File]::ReadAllText($commandInfo.Source)
    if ($Parameter) { $splat.Parameter = $Parameter }
    if ($ArgumentList) { $splat.ArgumentList = $ArgumentList }

    # Call the core inline transpiler.
    .>PipeScript.Inline @Splat
}
