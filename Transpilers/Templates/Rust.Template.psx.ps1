<#
.SYNOPSIS
    Rust Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate Rust.

    Multiline comments with /*{}*/ will be treated as blocks of PipeScript.
.EXAMPLE
    $HelloWorldRust = HelloWorld_Rust.rs template '    
    fn main() {
        let msg = /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
        println!("{}",msg);
    }
    '
    "$HelloWorldRust"
.EXAMPLE
    $HelloWorldRust = HelloWorld_Rust.rs template '    
    $HelloWorld = {param([Alias('msg')]$message = "Hello world") "`"$message`""}
    fn main() {
        let msg = /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
        println!("{}",msg);
    }
    '
    
    $HelloWorldRust.Evaluate('hi')
    $HelloWorldRust.Save(@{Message='Hello'}) |
        Foreach-Object { 
            $file = $_
            if (Get-Command rustc -commandType Application) {
                $null = rustc $file.FullName
                & ".\$($file.Name.Replace($file.Extension, '.exe'))"
            } else {
                Write-Error "Go install Rust"
            }
        }
.EXAMPLE
    '    
    fn main() {
        let msg = /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
        println!("{}",msg);
    }
    ' | Set-Content .\HelloWorld_Rust.ps.rs

    Invoke-PipeScript .\HelloWorld_Rust.ps.rs
.EXAMPLE
    $HelloWorld = {param([Alias('msg')]$message = "Hello world") "`"$message`""}
    "    
    fn main() {
        let msg = /*{$HelloWorld}*/ ;
        println!(`"{}`",msg);
    }
    " | Set-Content .\HelloWorld_Rust.ps1.rs

    Invoke-PipeScript .\HelloWorld_Rust.ps1.rs -Parameter @{message='hi'} |
        Foreach-Object { 
            $file = $_
            if (Get-Command rustc -commandType Application) {
                $null = rustc $file.FullName
                & ".\$($file.Name.Replace($file.Extension, '.exe'))"
            } else {
                Write-Error "Go install Rust"
            }
        }
#>
[ValidatePattern('\.rs$')]
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
    # * StartRegex     ```$IgnoredContext + $StartComment + '{' + $Whitespace```
    $startRegex = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment + $ignoredContext```
    $endRegex   = "(?<PSEnd>$Whitespace\}${endComment})"
    
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

    # If we are being used within a keyword,
    if ($AsTemplateObject) {
        $splat # output the parameters we would use to evaluate this file.
    } else {
        # Otherwise, call the core template transpiler
        .>PipeScript.Template @Splat # and output the changed file.
    }
}
