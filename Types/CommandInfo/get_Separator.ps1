# Allowing this to be set (caching what what set in .`.NamespaceSeparator`)
if ($this.'.Separator') {    
    if ($this.'.Separator' -is [regex]) {
        $this.'.Separator'
    } else {
        [Regex]::new("[" +
            [Regex]::Escape($this.'.Separator') +
        "]", 'RightToLeft')
    }
}
# Laying groundwork for some special/automatic variables
elseif ($psCommandNameSeparator) 
{
    if ($psCommandNameSeparator -is [string])  {
        [Regex]::new("[" +
            [Regex]::Escape($psCommandNameSeparator) +
        "]{1,}", 'RightToLeft')
    } elseif ($psCommandNameSeparator -is [regex]) {
        $psCommandNameSeparator
    }
}
else
{
    [Regex]::new('[\p{P}<>]{1,}','RightToLeft')
}
