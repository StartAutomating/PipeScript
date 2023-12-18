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

, @(
    foreach ($node in $this.ByType[@(
        [Microsoft.CodeAnalysis.CSharp.Syntax.ClassDeclarationSyntax]
        [Microsoft.CodeAnalysis.CSharp.Syntax.ClassOrStructConstraintSyntax]
        [Microsoft.CodeAnalysis.CSharp.Syntax.MemberDeclarationSyntax]
        [Microsoft.CodeAnalysis.CSharp.Syntax.EnumDeclarationSyntax]
    )]) {
        $node
    }
)
