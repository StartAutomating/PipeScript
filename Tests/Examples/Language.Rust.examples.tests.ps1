
describe 'Language.Rust' {
    it 'Language.Rust Example 1' {
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
    }
    it 'Language.Rust Example 2' {
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
    }
    it 'Language.Rust Example 3' {
        '    
        fn main() {
            let msg = /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
            println!("{}",msg);
        }
        ' | Set-Content .\HelloWorld_Rust.ps.rs

        Invoke-PipeScript .\HelloWorld_Rust.ps.rs
    }
    it 'Language.Rust Example 4' {
        $HelloWorld = {param([Alias('msg')]$message = "Hello world") "`"$message`""}
        "    
        fn main() {
            let msg = /*{$HelloWorld}*/ ;
            println!(`"{}`",msg);
        }
        " | Set-Content .\HelloWorld_Rust.ps1.rs

        Invoke-PipeScript .\HelloWorld_Rust.ps1.rs -Parameter @{message='hi'}
    }
}

