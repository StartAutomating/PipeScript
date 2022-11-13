<#
.SYNOPSIS
    OpenSCAD Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate OpenSCAD.
    
    Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

    Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

    This for Inline PipeScript to be used with operators, and still be valid OpenSCAD syntax. 

    The OpenSCAD Inline Transpiler will consider the following syntax to be empty:
    
    * ```"[^"]+"```
    * ```[\d\.]+```
.EXAMPLE
    .> {
        $OpenScadWithInlinePipeScript = @'
Shape = "cube" /*{'"cube"', '"sphere"', '"circle"' | Get-Random}*/;
Size  = 1 /*{Get-Random -Min 1 -Max 100}*/ ;

if (Shape == "cube") {
    cube(Size);
}
if (Shape == "sphere") {
    sphere(Size);
}
if (Shape == "circle") {
    circle(Size);
}
'@

        [OutputFile(".\RandomShapeAndSize.ps1.scad")]$OpenScadWithInlinePipeScript
    }
    
    .> .\RandomShapeAndSize.ps1.scad
#>
[ValidatePattern('\.scad$')]
param(
# The command information.  This will include the path to the file.
[Parameter(Mandatory,ValueFromPipeline)]
[Management.Automation.CommandInfo]
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
    # * IgnoredContext ```String.empty```, ```null```, blank strings and characters
    $IgnoredContext = "(?<ignore>(?>$('[\d\.]+','"[^"]+"' -join '|'))\s{0,}){0,1}"
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

    # If we are being used within a keyword,
    if ($AsTemplateObject) {
        $splat # output the parameters we would use to evaluate this file.
    } else {
        # Otherwise, call the core template transpiler
        .>PipeScript.Template @Splat # and output the changed file.
    }
}
