
describe 'Rust-Language' {
    it 'Rust-Language Example 1' {
        $HelloWorldRust = HelloWorld_Rust.rs template '    
        fn main() {
            let msg = /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
            println!("{}",msg);
        }
        '
        "$HelloWorldRust"
    }
    it 'Rust-Language Example 2' {
        $HelloWorldRust = HelloWorld_Rust.rs template '    
        $HelloWorld = {param([Alias(''msg'')]$message = "Hello world") "`"$message`""}
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
    }
    it 'Rust-Language Example 3' {
        '    
        fn main() {
            let msg = /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
            println!("{}",msg);
        }
        ' | Set-Content .\HelloWorld_Rust.ps.rs
        Invoke-PipeScript .\HelloWorld_Rust.ps.rs
    }
    it 'Rust-Language Example 4' {
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
    }
}

