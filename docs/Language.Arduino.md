Language.Arduino
----------------




### Synopsis
Arduino Template Transpiler.



---


### Description

Allows PipeScript to generate Arduino files.
Multiline comments with /*{}*/ will be treated as blocks of PipeScript.
Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.
The C++ Inline Transpiler will consider the following syntax to be empty:
* ```null```
* ```""```
* ```''```



---


### Syntax
```PowerShell
Language.Arduino [<CommonParameters>]
```
