<#
.SYNOPSIS
    Basic Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate Basic, Visual Basic, and Visual Basic Scripts.

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
[ValidatePattern('\.(?>bas|vbs{0,1})$')]
param(
# The command information.  This will include the path to the file.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='TemplateFile')]
[Management.Automation.CommandInfo]
$CommandInfo,

# If set, will return the information required to dynamically apply this template to any text.
[Parameter(Mandatory,ParameterSetName='TemplateObject')]
[switch]
$AsTemplateObject,

# A dictionary of parameters.
[Collections.IDictionary]
$Parameter,

# A list of arguments.
[PSObject[]]
$ArgumentList    
)

begin {
    # We start off by declaring a number of regular expressions:
    $startComment = '(?>(?<IsSingleLine>(?>''|rem))\s{0,}(?:PipeScript)?\s{0,}\{)'
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
    # If we have been passed a command
    if ($CommandInfo) {
        # add parameters related to the file.
        $Splat.SourceFile = $commandInfo.Source -as [IO.FileInfo]
        $Splat.SourceText = [IO.File]::ReadAllText($commandInfo.Source)
    }
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
