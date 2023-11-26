Language.Go
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
> EXAMPLE 1

```PowerShell
Invoke-PipeScript {    
    HelloWorld.go template '
package main
import "fmt"
func main() {
    fmt.Println("/*{param($msg = "hello world") "`"$msg`""}*/")
}
'
}
```
> EXAMPLE 2

```PowerShell
Invoke-PipeScript {
$HelloWorld = {param([Alias('msg')]$message = "Hello world") "`"$message`""}
$helloGo = HelloWorld.go template "
package main
import `"fmt`"
func main() {
    fmt.Println(`"/*{$helloWorld}*/`")
}
"

$helloGo.Save()
}
```
> EXAMPLE 3

```PowerShell
'
package main
import "fmt"
func main() {
    fmt.Println("hello world")
}
' | Set-Content .\HelloWorld.go
Invoke-PipeScript .\HelloWorld.go
```

---

### Syntax
```PowerShell
Language.Go [<CommonParameters>]
```
