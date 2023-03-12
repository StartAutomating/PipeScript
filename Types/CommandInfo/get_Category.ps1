@(foreach ($attr in $this.ScriptBlock.Attributes) {
    if ($attr -is [Reflection.AssemblyMetaDataAttribute] -and
        $attr.Key -eq 'Category') {
        $attr.Value
    }
    elseif ($attr -is [ComponentModel.CategoryAttribute]) {
        $attr.Category
    }
}) -as [string[]]