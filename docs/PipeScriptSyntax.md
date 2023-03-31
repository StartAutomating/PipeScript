# PipeScript Syntax

## PipeScript Syntax and PowerShell Syntax

PipeScript is en extension of the PowerShell language.  It's syntax is a superset of PowerShell's.

If you know PowerShell, expect every script you already have to keep working as is.
If this proves not to be true, please, [file an issue](https://github.com/StartAutomating/PipeScript).

## New Syntax

PipeScript also makes several additions to the PowerShell syntax (see our full [list of transpilers](ListOfTranspilers.md)).

We won't cover everything here, just a few key points.

## Attribute Based Composition

One of the more simple and open-ended capabilities of PipeScript's syntax is Attribute Based Composition.

PowerShell allows you to define attributes on any script or function.

PipeScript will treat any attribute that does not map to a real .NET type as a signal to search for a transpiler.

Let's show a short example:

~~~PowerShell
Import-PipeScript -ScriptBlock {
    function Get-MyProcess
    {
        <#
        .Synopsis
            Gets My Process
        .Description
            Gets the current process
        .Example
            Get-MyProcess
        .Link
            Get-Process
        #>
        [inherit('Get-Process',Abstract,ExcludeParameter='Name','ID','InputObject','IncludeUserName')]
        param()

        return & $baseCommand -id $pid @PSBoundParameters
    }
}
~~~

Running this example will create and import a function, Get-MyProcess, that inherits from Get-Process (excluding the parameters -Name, -ID, -InputObject, and -IncludeUserName).

## Inheriting commands

As the above example demonstrates, PipeScript makes it possible to inherit commands.  An inherited command will have most of the shape of it's parent command, but can do anything it wishes.

We can also inherit an application, allowing us to override it's input and output.

~~~PowerShell
Import-PipeScript -ScriptBlock {
    function NPM
    {
        [inherit('npm',CommandType='Application')]
        param()

        begin {
            "Calling Node Platform Manager" 
        }
        end {
            "Done Calling Node Platform Manager"
        }
    }
}
~~~

## Namespaced Commands

It is easy to logically group commands using PipeScript (in more ways than PowerShell's verb-noun convention).

Functions and Aliases can be defined in a namespace, which can allow all commands with that naming convention to be treated consistently.

You can define a namespaced function by putting the namespace directly before the word function, for example:

~~~PowerShell
Import-

This will become:
~~~PowerShell
function partial.PartialExample { 1 }
~~~

Namespaces can be used to group functionality.

Commands in some namespaces do special things in PipeScript.

### Partial Commands

`Partial` is the first special namespace in PipeScript.

Whenever a function is transpiled, it will check for applicable partial functions.

Let's take a look at an example containing all three ways we can do this:

~~~PowerShell
{
    partial function PartialExample {
        process { 1 }
    }

    partial function PartialExample* {
        process { 2 }
    }

    partial function PartialExample// {
        process { 3 }
    }        

    function PartialExample {}
} | Import-PipeScript

PartialExample
~~~

This will return:

~~~
1
2
3
~~~

PartialExample is an empty function, but it has 3 partials defined.

`partial function PartialExample` will become `function partial.PartialExample`

This will be joined with PartialExample, because the partial name and function name are equal.

`partial function PartialExample*` will become `function partial.PartialExample*`

This will be joined with PartialExample, because the partial name contains a wildcard character, and the function name is like the partial name.

`partial function PartialExample//` will become `function partial.PartialExample//`

This will be joined with PartialExample, because the partial name contains slashes, indicating a simple Regex.


## PipeScript Programmer Friendliness

PipeScript tries to make the PowerShell syntax a bit more programmer friendly.

### ==

PipeScript supports the use of ==, providing the left hand side is a variable.

~~~PowerShell
Invoke-True

PipeScript also supports the use of ===

### Conditional Keywords

PipeScript supports the use of conditional keywords, which can remove a few excess braces from your code.

~~~PowerShell
Invoke-10
