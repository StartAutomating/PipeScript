<#
.SYNOPSIS
    Gets all Variables within an AST
.DESCRIPTION
    Gets all Variable and Field Definitions within a CSharp Abstract Syntax Tree
.EXAMPLE
    Parse-CSharp ('
        public class MyClass {
            public void MyMethod() {
                string bar = "bar";
            }
            public int foo = 1;
        }
    ').Variables
#>
@(

foreach ($node in $this.ByType[
    @(
        [Microsoft.CodeAnalysis.CSharp.Syntax.FieldDeclarationSyntax]
        [Microsoft.CodeAnalysis.CSharp.Syntax.VariableDeclarationSyntax]
    )
]) {
    $node
}

)