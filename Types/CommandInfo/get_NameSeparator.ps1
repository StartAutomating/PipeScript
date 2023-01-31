# Allowing this to be set (caching what what set in .`.NamespaceSeparator`)
if ($this.'.NameSeparator') {    
    if ($this.'.NameSeparator' -is [regex]) {
        $this.'.NameSeparator'
    } else {
        [Regex]::new("[" +
            [Regex]::Escape($this.'.NameSeparator') +
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
    [Regex]::new('[\p{P}]{1,}','RightToLeft')
}
