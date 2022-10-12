---

title: Commands could be read as sentences
author: StartAutomating
sourceURL: https://github.com/StartAutomating/PipeScript/issues/242
tag: enhancement
---
Almost any given sentence could be considered valid PowerShell (including this one).

What if we could parse a command as a sentence?

## How?

One could map a sentence to a command in a natural language syntax.

This can be done by:
* Walking over the `[AST]`
* Treating a `[CommandParameter]`s normally, and consider them the start of a clause
* Any bareword that is a parameter name/alias (or /parameter or --parameter) will mark the start of a clause
* Any arguments between two parameters will be considered part of the same clause
* If a command has a parameter with `ValueFromRemainingArguments`, unbound parameters will be bound to it
* Otherwise, they will be returned in their own clause

So algorithmically, this is pretty straightforward.

## Why?

If you treated a commands a sentences, instead of the way it would normally be parsed in PowerShell, it looks shorter and reads more naturally:

For Example, here are some alternative ways to write Get-Process:

~~~PowerShell
Get-Process -Name powershell -IncludeUserName
~~~

~~~PowerShell
Get-Process Name powershell IncludeUserName pwsh
Get-Process IncludeUserName Name powershell pwsh
Get-Process /IncludeUserName --Name powershell pwsh
~~~

In the trio of examples, there should be two clauses in the sentence, ```Name PowerShell``` and ```IncludeUserName```

## PipeScript Keywords and Natural Syntax  

One of the pain points with writing a PipeScript keyword has been how to structure it's arguments.  Because keywords are parsing a CommandAST that has not run, even if one defined parameters on the keyword, they wouldn't be automatically bound.

Thus there has been a need to have a consistent way to "pre-parse" a keyword.

Additionally, there's been the desire to make PipeScript's syntax even more high level than PowerShell's.

Want an example?  In the same Pull Request in which Natural Syntax support was introduced, the ['all' keyword](https://github.com/StartAutomating/PipeScript/issues/244) was introduced.

This leads to the wonderfully natural syntax you see below.

~~~PowerShell
all functions that AsJob    # would get all -Functions -That have an -AsJob parameter
~~~

That's some pretty readable code, right?

Moving forward, expect to see most new keywords using this natural language format.
