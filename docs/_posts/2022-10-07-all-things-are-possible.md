---

title: all things are possible
author: StartAutomating
sourceURL: https://github.com/StartAutomating/PipeScript/issues/244
tag: enhancement
---
The title of this post may be cheeky.  It would also be valid syntax.

It would translate to:

* Find all variables, functions, aliases, and cmdlets 
* Iterate over each of them, interesting the PSTypeName 'possible'

The [all keyword](https://github.com/StartAutomating/PipeScript/blob/main/Transpilers/Keywords/All.psx.ps1) is a new keyword introduced in [PipeScript 0.1.6](https://github.com/StartAutomating/PipeScript/releases/tag/v0.1.6).

`all` is an iterator over everything.

`all` can be followed by a number of modifiers or an input variable.

~~~PowerShell
all functions      # returns all functions
all aliases          # returns all aliases
all cmdlets        # returns all cmdlets
all applications # returns all applications
all commands   # returns all commands
all variables      # returns all variables
all things          # returns all variables, functions, cmdlets, aliases
all $numbers    # returns everything in numbers
~~~
