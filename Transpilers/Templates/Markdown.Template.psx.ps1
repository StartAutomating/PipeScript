<#
.SYNOPSIS
    Markdown Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate Markdown.

    Because Markdown does not support comment blocks, PipeScript can be written inline inside of specialized Markdown code blocks.

    PipeScript can be included in a Markdown code block that has the Language ```PipeScript{```
    
    In Markdown, PipeScript can also be specified as the language using any two of the following characters ```.<>```
.Example
    .> {
        $markdownContent = @'
# Thinking of a Number Between 1 and 100: ```.<{Get-Random -Min 1 -Max 100}>.``` is the number

### abc

~~~PipeScript{
    '* ' + @("a", "b", "c" -join ([Environment]::Newline + '* '))
}
~~~

#### Guess what, other code blocks are unaffected
~~~PowerShell
1 + 1 -eq 2
~~~


'@
        [OutputFile('.\HelloWorld.ps1.md')]$markdownContent
    }

    .> .\HelloWorld.ps1.md
#>
[ValidatePattern('\.(?>md|markdown|txt)$')]
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
    # Note: Markdown is one of the more complicated templates.

    # This is because Markdown isn't _just_ Markdown.  Markdown allows inline HTML.  Inline HTML, in turn, allows inline JavaScript and CSS.
    # Also, Markdown code blocks can be provided a few different ways, and thus PipeScript can be embedded a few different ways.

    $StartConditions = 
        '# three ticks can start an inline code block
        (?>`{3})
        [\.\<\>]{2} # followed by at least 2 of .<>',
        '# Or three ticks or tilda, followed by PipeScript.        
        (?>`{3}|~{3})
        PipeScript',
        '# Or a single tick, followed by a literal pipe
        `\|',
        '
        # Or an HTML comment start
        <\!--',
        
        '
        # Or a JavaScript/CSS comment start
        /\*
        '

    $endConditions = @(        
        '# Or a literal pipe, followed by a single tick
        \|`',
        '[\.\<\>]{2} # At least 2 of .<>
        `{3} # followed by 3 ticks ',
        '# Or three ticks or tildas
        (?>`{3}|~{3})',
        '# or HTML comment end
        -->',
        '# or JavaScript/CSS comment end
        \*/
        '
    )


    $startComment = "(?>
$($StartConditions -join ([Environment]::NewLine + '  |' + [Environment]::NewLine))        
    )\s{0,}
    # followed by a bracket and any opening whitespace.
    \{\s{0,}
"
    
    $endComment   = "
    \}
    \s{0,}
    (?>
$($endConditions -join ([Environment]::NewLine + '  |' + [Environment]::NewLine))
    )
    "
    
    
    $startRegex = "(?<PSStart>${startComment})"
    # * EndRegex       ```$whitespace + '}' + $EndComment```
    $endRegex   = "(?<PSEnd>${endComment})"

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
    $Splat.ForeachObject = {
        process {
            if ($_ -is [string]) {
                $_
            } elseif ($_.GetType -and $_.GetType().IsPrimitive) {
                $_
            } else {
                $markdownObject = [PSObject]::new($_)
                $markdownObject.pstypenames.clear()
                $markdownObject.pstypenames.add('Markdown')
                $markdownObject | Out-String -Width 1kb
            }
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