<#
.SYNOPSIS
    JavaScript Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate JavaScript.

    Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

    String output from these blocks will be embedded directly.  All other output will be converted to JSON.

    Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

    The JavaScript Inline Transpiler will consider the following syntax to be empty:

    * ```undefined```
    * ```null```
    * ```""```
    * ```''```
.EXAMPLE
    $helloJs = Hello.js template '
    msg = null /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
    if (console) {
        console.log(msg);
    }
    '
.EXAMPLE
    $helloMsg = {param($msg = 'hello world') "`"$msg`""}
    $helloJs = HelloWorld.js template "
    msg = null /*{$helloMsg}*/;
    if (console) {
        console.log(msg);
    }
    "
#>
[ValidatePattern('\.js$')]
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
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext ```String.empty```, ```null```, blank strings and characters
    $IgnoredContext = "(?<ignore>(?>$("undefined", "null", '""', "''" -join '|'))\s{0,}){0,1}"
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
    # If we have been passed a command
    if ($CommandInfo) {
        # add parameters related to the file.
        $Splat.SourceFile = $commandInfo.Source -as [IO.FileInfo]
        $Splat.SourceText = [IO.File]::ReadAllText($commandInfo.Source)
    }

    if ($Parameter) { $splat.Parameter = $Parameter }
    if ($ArgumentList) { $splat.ArgumentList = $ArgumentList }
    $splat.ForeachObject = {
        $in = $_
        if (($in -is [string]) -or 
            ($in -ne $null -and $in.GetType().IsPrimitive)) {
            "$in"
        } else {
            "$(ConvertTo-Json -Depth 100 -InputObject $in)"
        }
    }

    # If we are being used within a keyword,
    if ($AsTemplateObject) {
        $splat # output the parameters we would use to evaluate this file.
    } else {
        # Otherwise, call the core template transpiler
        .>PipeScript.Template @Splat # and output the changed file.
    }
    
}
