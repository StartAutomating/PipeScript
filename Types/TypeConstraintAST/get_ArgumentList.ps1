if (-not $this.TypeName.IsGeneric) { return @() }
@(foreach ($typeName in $this.TypeName.GenericArguments ) {
    if ($TypeName.IsGeneric) { continue }
    if (-not $TypeName.IsArray) {
        $TypeName.Name
    }
})
