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

Here's a table of some simple ways to use `all`

|Example              | Description                                                         |
|------------------:|:----------------------------------------------------|
|`all functions`      | outputs all functions                                          |
|`all aliases`          | outputs all aliases                                               |
|`all cmdlets`        | outputs all cmdlets                                             |
|`all applications` | outputs all applications                                      |
|`all commands ` | outputs all commands                                        |
|`all variables`      | outputs all variables                                           |
|`all things`          | outputs all variables, functions, cmdlets, aliases|
|`all $numbers`    | outputs everything in numbers                          |



