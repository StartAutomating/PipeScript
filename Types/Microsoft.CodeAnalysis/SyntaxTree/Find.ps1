<#
.SYNOPSIS
    Finds a CSharp Node
.DESCRIPTION
    Finds a single CSharp Syntax Node that meets any one of a number of criteria
.EXAMPLE
    (Parse-CSharp 'Console.WriteLine("Hello World");').Find("*hello*")
#>
$this.Root.Find.Invoke($args)
