<#
.SYNOPSIS
    Gets the root of a Syntax Tree
.DESCRIPTION
    Gets the root of a CSharp Abstract Syntax Tree
.EXAMPLE
    (Parse-CSharp 'Console.WriteLine("Hello world");').Root
#>
if (-not $this.'.Root') {    
    $rootObject = $this.GetRoot()
    $rootObject | Add-Member NoteProperty '.Tree' $this -Force
    $this | Add-Member NoteProperty '.Root' $rootObject -Force
}

$this.'.Root'

