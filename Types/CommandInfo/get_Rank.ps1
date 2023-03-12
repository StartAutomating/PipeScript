foreach ($attr in $this.ScriptBlock.Attributes) {
    if ($attr -is [Reflection.AssemblyMetaDataAttribute] -and
        $attr.Key -in 'Order', 'Rank') {
        return $attr.Value -as [int]
    }
}
return 0