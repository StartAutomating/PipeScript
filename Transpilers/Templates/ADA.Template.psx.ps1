<#
.SYNOPSIS
    ADA Template Transpiler.
.DESCRIPTION
    Allows PipeScript to be used to generate ADA.
    
    Because ADA Scripts only allow single-line comments, this is done using a pair of comment markers.

    -- { or -- PipeScript{  begins a PipeScript block

    -- } or -- }PipeScript  ends a PipeScript block                
.EXAMPLE
    Invoke-PipeScript {
        HelloWorld.adb template '    
    with Ada.Text_IO;

    procedure Hello_World is
    begin
        -- {

        Uncommented lines between these two points will be ignored

        --  # Commented lines will become PipeScript / PowerShell.
        -- param($message = "hello world")        
        -- "Ada.Text_IO.Put_Line (`"$message`");"
        -- }
    end Hello_World;    
    '
    }

    Invoke-PipeScript .\HelloWorld.ps1.adb
#>
[ValidatePattern('\.ad[bs]$')]
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
    $startComment = '(?>--\s{0,}(?:PipeScript)?\s{0,}\{)'
    $endComment   = '(?>--\s{0,}\}\s{0,}(?:PipeScript)?\s{0,})'        
    $startRegex = "(?<PSStart>${startComment})"
    $endRegex   = "(?<PSEnd>${endComment})"

    # Create a splat containing arguments to the core inline transpiler
    $Splat      = [Ordered]@{
        StartPattern  = $startRegex
        EndPattern    = $endRegex
         # Using -LinePattern will skip any inline code not starting with --
        LinePattern   = "^\s{0,}--\s{0,}"
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

