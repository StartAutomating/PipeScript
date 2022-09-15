
Inline.CSharp
-------------
### Synopsis
C# Inline PipeScript Transpiler.

---
### Description

Transpiles C# with Inline PipeScript into C#.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

This for Inline PipeScript to be used with operators, and still be valid C# syntax. 

The C# Inline Transpiler will consider the following syntax to be empty:

* ```String.Empty```
* ```null```
* ```""```
* ```''```

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    $CSharpLiteral = @&#39;
namespace TestProgram/*{Get-Random}*/ {
public static class Program {
    public static void Main(string[] args) {
        string helloMessage = /*{
            &#39;&quot;hello&quot;&#39;, &#39;&quot;hello world&quot;&#39;, &#39;&quot;hey there&quot;&#39;, &#39;&quot;howdy&quot;&#39; | Get-Random
        }*/ string.Empty; 
        System.Console.WriteLine(helloMessage);
    }
}
}    
&#39;@
```
[OutputFile(".\HelloWorld.ps1.cs")]$CSharpLiteral
}

$AddedFile = .> .\HelloWorld.ps1.cs
$addedType = Add-Type -TypeDefinition (Get-Content $addedFile.FullName -Raw) -PassThru
$addedType::Main(@())
#### EXAMPLE 2
```PowerShell
// HelloWorld.ps1.cs
namespace TestProgram {
    public static class Program {
        public static void Main(string[] args) {
            string helloMessage = /*{
                &#39;&quot;hello&quot;&#39;, &#39;&quot;hello world&quot;&#39;, &#39;&quot;hey there&quot;&#39;, &#39;&quot;howdy&quot;&#39; | Get-Random
            }*/ string.Empty; 
            System.Console.WriteLine(helloMessage);
        }
    }
}
```

---
### Parameters
#### **CommandInfo**

The command information.  This will include the path to the file.



> **Type**: ```[CommandInfo]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByValue)



---
#### **Parameter**

A dictionary of parameters.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:false



---
#### **ArgumentList**

A list of arguments.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:false



---
### Syntax
```PowerShell
Inline.CSharp [-CommandInfo] &lt;CommandInfo&gt; [[-Parameter] &lt;IDictionary&gt;] [[-ArgumentList] &lt;PSObject[]&gt;] [&lt;CommonParameters&gt;]
```
---



