$Metadata = [Ordered]@{}
foreach ($attr in $this.ScriptBlock.Attributes) {
    if ($attr -is [Reflection.AssemblyMetaDataAttribute]) {
        if ($Metadata[$attr.Key]) {
            $Metadata[$attr.Key] = @($Metadata[$attr.Key]) + $attr.Value
        } else {
            $Metadata[$attr.Key] = $attr.Value
        }                            
    }
}
return $Metadata