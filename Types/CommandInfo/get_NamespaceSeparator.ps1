# Allowing this to be set (caching what what set in .`.NamespaceSeparator`)
if ($this.'.NamespaceSeparator') {    
    if ($this.'.NamespaceSeparator' -is [regex]) {
        $this.'.NamespaceSeparator'
    } else {
        [Regex]::new("[" +
            [Regex]::Escape($this.'.NamespaceSeparator') +
        "]", 'RightToLeft')
    }
}
# Laying future groundwork for some special/automatic variables
elseif ($psCommandNamespaceSeparator) 
{
    if ($psCommandNamespaceSeparator -is [string])  {
        [Regex]::new("[" +
            [Regex]::Escape($psCommandNamespaceSeparator) +
        "]", 'RightToLeft')
    } elseif ($psCommandNamespaceSeparator -is [regex]) {
        $psCommandNamespaceSeparator
    }
}
else
{
    [Regex]::new('[\.\\/]','RightToLeft')
}
