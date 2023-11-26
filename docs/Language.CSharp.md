Language.CSharp
---------------

### Synopsis
C# Language Definition.

---

### Description

Allows PipeScript to Generate C#.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

The C# Inline Transpiler will consider the following syntax to be empty:

* ```String.Empty```
* ```null```
* ```""```
* ```''```

---

### Examples
> EXAMPLE 1

```PowerShell
{
    $CSharpLiteral = '
namespace TestProgram/*{Get-Random}*/ {
public static class Program {
    public static void Main(string[] args) {
        string helloMessage = /*{
            ''"hello"'', ''"hello world"'', ''"hey there"'', ''"howdy"'' | Get-Random
        }*/ string.Empty; 
        System.Console.WriteLine(helloMessage);
    }
}
}    
'
[OutputFile(".\HelloWorld.ps1.cs")]$CSharpLiteral
}

$AddedFile = .> .\HelloWorld.ps1.cs
$addedType = Add-Type -TypeDefinition (Get-Content $addedFile.FullName -Raw) -PassThru
$addedType::Main(@())
```

---

### Syntax
```PowerShell
Language.CSharp [<CommonParameters>]
```
