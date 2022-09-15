
OutputFile
----------
### Synopsis
Outputs to a File

---
### Description

Outputs the result of a script into a file.

---
### Examples
#### EXAMPLE 1
```PowerShell
Invoke-PipeScript {
    [OutputFile(&quot;hello.txt&quot;)]
    param()
```
'hello world'
}
#### EXAMPLE 2
```PowerShell
Invoke-PipeScript {
    param()
```
$Message = 'hello world'
    [Save(".\Hello.txt")]$Message
}
---
### Parameters
#### **OutputPath**

The Output Path



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **ScriptBlock**

The Script Block that will be run.



> **Type**: ```[ScriptBlock]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByValue)



---
#### **VariableAst**

> **Type**: ```[VariableExpressionAst]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByValue)



---
#### **Encoding**

The encoding parameter.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:false



---
#### **Force**

If set, will force output, overwriting existing files.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ExportScript**

The export script



> **Type**: ```[ScriptBlock]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:false



---
#### **Depth**

The serialization depth.  Currently only used when saving to JSON files.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: 6

> **PipelineInput**:false



---
### Syntax
```PowerShell
OutputFile [-OutputPath] &lt;String&gt; [[-ScriptBlock] &lt;ScriptBlock&gt;] [[-VariableAst] &lt;VariableExpressionAst&gt;] [[-Encoding] &lt;String&gt;] [-Force] [[-ExportScript] &lt;ScriptBlock&gt;] [[-Depth] &lt;Int32&gt;] [&lt;CommonParameters&gt;]
```
---



