<#
.SYNOPSIS
    Gets arguments of a type constraint
.DESCRIPTION
    Gets the arguments from a type constraint.

    This will treat any generic type specifiers as potential parameters, and other type specifiers as arguments.
.EXAMPLE
    {
        [a[b[c],c]]'d'
    }.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Type.ArgumentList
#>
if (-not $this.TypeName.IsGeneric) { return @() }
@(foreach ($typeName in $this.TypeName.GenericArguments ) {
    if ($TypeName.IsGeneric) { continue }
    if (-not $TypeName.IsArray) {
        $TypeName.Name
    }
})
