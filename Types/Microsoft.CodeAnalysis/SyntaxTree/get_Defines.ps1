<#
.SYNOPSIS
    Gets all Definitions within an AST
.DESCRIPTION
    Gets all Class and Type Definitions within a CSharp Abstract Syntax Tree
.EXAMPLE
    Parse-CSharp ('
        public class MyClass {
            public void MyMethod();    
        }
    ').Defines
#>

return $this.Root.Defines
