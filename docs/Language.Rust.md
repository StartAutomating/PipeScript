Language.Rust
-------------

### Synopsis
Rust PipeScript Language Definition

---

### Description

Defines Rust within PipeScript.

This allows Rust to be templated.

---

### Examples
> EXAMPLE 1

```PowerShell
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
```
> EXAMPLE 2

```PowerShell
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
```
> EXAMPLE 3

```PowerShell
'    
fn main() {
    let msg = /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
    println!("{}",msg);
}
' | Set-Content .\HelloWorld_Rust.ps.rs
Invoke-PipeScript .\HelloWorld_Rust.ps.rs
```
> EXAMPLE 4

```PowerShell
$HelloWorld = {param([Alias('msg')]$message = "Hello world") "`"$message`""}
"    
fn main() {
    let msg = /*{$HelloWorld}*/ ;
    println!(`"{}`",msg);
}
" | Set-Content .\HelloWorld_Rust.ps1.rs
Invoke-PipeScript .\HelloWorld_Rust.ps1.rs -Parameter @{message='hi'}
```

---

### Syntax
```PowerShell
Language.Rust [<CommonParameters>]
```
