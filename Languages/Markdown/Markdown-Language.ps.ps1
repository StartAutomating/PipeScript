[ValidatePattern("(?>Markdown|Language)[\s\p{P}]")]
param()

Language function Markdown {
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
# Thinking of a Number Between 1 and 100: `|{Get-Random -Min 1 -Max 100}|` is the number

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
    param()

    $FilePattern = '\.(?>md|markdown|txt)$'


    # Note: Markdown is one of the more complicated templates (at least from a Regex perspective)

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
    
    
    $StartPattern = "(?<PSStart>${startComment})"
    # * EndRegex       ```$whitespace + '}' + $EndComment```
    $EndPattern   = "(?<PSEnd>${endComment})"
    $ForeachObject = {
        process {
            $in = $_
            if ($in -is [string]) {
                $in
            } elseif ($in.GetType -and $in.GetType().IsPrimitive) {
                $in
            } 
            elseif ($in -is [Regex]) {
                $markdownObject = [PSCustomObject][Ordered]@{PSTypeName='Markdown';Code="$in";CodeLanguage='regex'}                
                $markdownObject | Out-String -Width 1kb
            }
            else {
                $markdownObject = [PSObject]::new($_)
                $markdownObject.pstypenames.clear()
                $markdownObject.pstypenames.add('Markdown')
                $markdownObject | Out-String -Width 1kb
            }
        }
    }
}