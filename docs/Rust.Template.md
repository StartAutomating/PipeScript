Rust.Template
-------------
### Synopsis
Rust Template Transpiler.

---
### Description

Allows PipeScript to generate Rust.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

---
### Examples
#### EXAMPLE 1
```PowerShell
$HelloWorldRust = HelloWorld_Rust.rs template '    
fn main() {
    let msg = /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
    println!("{}",msg);
}
'
"$HelloWorldRust"
```

#### EXAMPLE 2
```PowerShell
$HelloWorldRust = HelloWorld_Rust.rs template '    
$HelloWorld = {param([Alias('msg')]$message = "Hello world") "`"$message`""}
fn main() {
    let msg = /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
    println!("{}",msg);
}
'
```
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
#### EXAMPLE 3
```PowerShell
'    
fn main() {
    let msg = /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
    println!("{}",msg);
}
' | Set-Content .\HelloWorld_Rust.ps.rs
```
Invoke-PipeScript .\HelloWorld_Rust.ps.rs
#### EXAMPLE 4
```PowerShell
$HelloWorld = {param([Alias('msg')]$message = "Hello world") "`"$message`""}
"    
fn main() {
    let msg = /*{$HelloWorld}*/ ;
    println!(`"{}`",msg);
}
" | Set-Content .\HelloWorld_Rust.ps1.rs
```
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
---
### Parameters
#### **CommandInfo**

The command information.  This will include the path to the file.



> **Type**: ```[CommandInfo]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
#### **AsTemplateObject**

If set, will return the information required to dynamically apply this template to any text.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **Parameter**

A dictionary of parameters.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ArgumentList**

A list of arguments.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
Rust.Template -CommandInfo <CommandInfo> [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
Rust.Template -AsTemplateObject [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
---

