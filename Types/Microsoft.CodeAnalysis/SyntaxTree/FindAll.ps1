<#
.SYNOPSIS
    Finds all CSharp Nodes
.DESCRIPTION
    Finds all CSharp Syntax Nodes that meet any one of a number of criteria
.EXAMPLE
    (Parse-CSharp 'Console.WriteLine("Hello World");').FindAll("*hello*")
#>
$this.Root.FindAll.Invoke($args)
