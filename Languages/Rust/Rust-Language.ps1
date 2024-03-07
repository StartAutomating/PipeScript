[ValidatePattern("(?>Rust|Language)[\s\p{P}]")]
param()


function Language.Rust {
<#
    .SYNOPSIS
        Rust PipeScript Language Definition
    .DESCRIPTION
        Defines Rust within PipeScript.

        This allows Rust to be templated.
    .EXAMPLE
        Invoke-PipeScript -ScriptBlock {
            $HelloWorldRustString = '    
            fn main() {
                let msg = /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
                println!("{}",msg);
            }
            '
            $HelloWorldRust = template HelloWorld_Rust.rs $HelloWorldRustString
            "$HelloWorldRust"
        }
    .EXAMPLE
        Invoke-PipeScript -ScriptBlock {
            $HelloWorldRust = template HelloWorld_Rust.rs '    
            $HelloWorld = {param([Alias(''msg'')]$message = "Hello world") "`"$message`""}
            fn main() {
                let msg = /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
                println!("{}",msg);
            }
            '
        
            $HelloWorldRust.Evaluate('hi')
            $HelloWorldRust.Save(@{Message='Hello'})
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

        Invoke-PipeScript .\HelloWorld_Rust.ps1.rs -Parameter @{message='hi'}
    #>
[ValidatePattern('\.rs$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()

    # Rust files end in .rs:
    $FilePattern  = '\.rs$'

    # Rust is case-sensitive
    $CaseSensitive = $true

    # A Rust Project file is described in a `Cargo.toml`.
    $ProjectFilePattern = 'Cargo.toml$'
    
    # They used C-style comments `/* */`
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartPattern  ```$IgnoredContext + $StartComment + '{' + $Whitespace```
    $StartPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndPattern    ```$whitespace + '}' + $EndComment + $ignoredContext```
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment})"

    $compiler = 'rustc'

    $Website = 'https://www.rust-lang.org/'
    $ProjectUri = 'https://github.com/rust-lang/rust'
    $LanguageName = 'Rust'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Rust")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}

