
Inline.Markdown
---------------
### Synopsis
Markdown File Transpiler.

---
### Description

Transpiles Markdown with Inline PipeScript into Markdown.

Because Markdown does not support comment blocks, PipeScript can be written inline inside of specialized Markdown code blocks.

PipeScript can be included in a Markdown code block that has the Language ```PipeScript{```

In Markdown, PipeScript can also be specified as the language using any two of the following characters ```.<>```

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    $markdownContent = @'
# Thinking of a Number Between 1 and 100: ```.<{Get-Random -Min 1 -Max 100}>.``` is the number
```
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
---
### Parameters
#### **CommandInfo**

The command information.  This will include the path to the file.



|Type               |Requried|Postion|PipelineInput |
|-------------------|--------|-------|--------------|
|```[CommandInfo]```|true    |1      |true (ByValue)|
---
#### **Parameter**

A dictionary of parameters.



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[IDictionary]```|false   |2      |false        |
---
#### **ArgumentList**

A list of arguments.



|Type              |Requried|Postion|PipelineInput|
|------------------|--------|-------|-------------|
|```[PSObject[]]```|false   |3      |false        |
---
### Syntax
```PowerShell
Inline.Markdown [-CommandInfo] <CommandInfo> [[-Parameter] <IDictionary>] [[-ArgumentList] <PSObject[]>] [<CommonParameters>]
```
---



