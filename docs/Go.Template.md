Go.Template
-----------




### Synopsis
Go Template Transpiler.



---


### Description

Allows PipeScript to Generate Go.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

This for Inline PipeScript to be used with operators, and still be valid Go syntax. 

The Go Transpiler will consider the following syntax to be empty:

* ```nil```
* ```""```
* ```''```



---


### Examples
#### EXAMPLE 1
```PowerShell
$helloGo = HelloWorld.go template '
package main
```
import "fmt"
func main() {
    fmt.Println("/*{param($msg = "hello world") "`"$msg`""}*/")
}
'
#### EXAMPLE 2
```PowerShell
$HelloWorld = {param([Alias('msg')]$message = "Hello world") "`"$message`""}
$helloGo = HelloWorld.go template "
package main
```
import `"fmt`"
func main() {
    fmt.Println(`"/*{$helloWorld}*/`")
}
"

$helloGo.Save() | 
    Foreach-Object { 
        $file = $_
        if (Get-Command go -commandType Application) {
            $null = go build $file.FullName
            & ".\$($file.Name.Replace($file.Extension, '.exe'))"
        } else {
            Write-Error "Go install Go"
        }
    }


---


### Parameters
#### **CommandInfo**

The command information.  This will include the path to the file.






|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[CommandInfo]`|true    |named   |true (ByValue)|



#### **AsTemplateObject**

If set, will return the information required to dynamically apply this template to any text.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|true    |named   |false        |



#### **Parameter**

A dictionary of parameters.






|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |named   |false        |



#### **ArgumentList**

A list of arguments.






|Type          |Required|Position|PipelineInput|
|--------------|--------|--------|-------------|
|`[PSObject[]]`|false   |named   |false        |





---


### Syntax
```PowerShell
Go.Template -CommandInfo <CommandInfo> [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
Go.Template -AsTemplateObject [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```

