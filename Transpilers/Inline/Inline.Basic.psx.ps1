<#
.SYNOPSIS
    Basic PipeScript Transpiler.
.DESCRIPTION
    Transpiles Basic, Visual Basic, and Visual Basic Scripts with Inline PipeScript.

    Because Basic only allow single-line comments, this is done using a pair of comment markers.

    A single line comment, followed by a { (or PipeScript { ) begins a block of pipescript.

    A single line comment, followed by a } (or PipeScript } ) ends a block of pipescript.

    Only commented lines within this block will be interpreted as PipeScript.
            
    ```VBScript    
    rem {

    Uncommented lines between these two points will be ignored

    rem # Commented lines will become PipeScript / PowerShell.
    rem param($message = "hello world")
    rem "CreateObject(`"WScript.Shell`").Popup(`"$message`")" 
    rem }
    ```
.EXAMPLE
    Invoke-PipeScript {
        $VBScript = '    
    rem {

    Uncommented lines between these two points will be ignored

    rem # Commented lines will become PipeScript / PowerShell.
    rem param($message = "hello world")
    rem "CreateObject(`"WScript.Shell`").Popup(`"$message`")" 
    rem }
    '
    
        [OutputFile('.\HelloWorld.ps1.vbs')]$VBScript
    }

    Invoke-PipeScript .\HelloWorld.ps1.vbs
#>
[ValidateScript({
    $cmdInfo = $_
    if ($cmdInfo.Source -match '\.vbs{0,1}$') {
        return $true
    }
    return $false    
})]
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
    $startComment = '(?>(?>''|rem)\s{0,}(?:PipeScript)?\s{0,}\{)'
    $endComment   = '(?>(?>''|rem)\s{0,}(?:PipeScript)?\s{0,}\})'        
    $startRegex = "(?<PSStart>${startComment})"
    $endRegex   = "(?<PSEnd>${endComment})"

    # Create a splat containing arguments to the core inline transpiler
    $Splat      = [Ordered]@{
        StartPattern  = $startRegex
        EndPattern    = $endRegex
         # Using -LinePattern will skip any inline code not starting with ' or rem.
        LinePattern   = "^\s{0,}(?>'|rem)\s{0,}"
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
