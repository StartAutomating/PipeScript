
describe 'Language.Markdown' {
    it 'Language.Markdown Example 1' {
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
    }
}

