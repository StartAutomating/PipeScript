<#
.SYNOPSIS
    Markdown File Transpiler.
.DESCRIPTION
    Transpiles Markdown with Inline PipeScript into Markdown.

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
[ValidateScript({
    $cmdInfo = $_
    if ($cmdInfo.Source -match '\.(?>md|markdown)$') {
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
    
    $startComment = '(?>                
        (?>```|~~~) |
        (?<=(?>[\r\n]+){1})[\s-[\r\n]]{0,3}(?>```|~~~) 
    ){1}(?>[\.\<\>]{2}|PipeScript)\s{0,}\{\s{0,}' 
    $endComment   = '\}(?>[\.\<\>]{2}|PipeScript){0,1}(?>
        \s{0,}(?>[\r\n]+){1}\s{0,3}(?>```|~~~)        
        |
        (?>```|~~~)
    )
    '
    
    $startRegex = "(?<PSStart>${startComment})"
    # * EndRegex       ```$whitespace + '}' + $EndComment```
    $endRegex   = "(?<PSEnd>${endComment})"
}

process {
    
    $foreachMarkdownOutput = {
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

    $fileInfo = $commandInfo.Source -as [IO.FileInfo]
    $fileText      = [IO.File]::ReadAllText($fileInfo.Fullname)    

    .>PipeScript.Inline -SourceFile $CommandInfo.Source -SourceText $fileText -StartPattern $startRegex -EndPattern $endRegex -ForeachObject $foreachMarkdownOutput    
}