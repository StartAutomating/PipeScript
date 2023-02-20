if (-not $this.'.CommandMetadata') {
    $this.psobject.properties.add(
        [psnoteproperty]::new('.CommandMetadata', 
            [PSObject]::new([Management.Automation.CommandMetadata]::new($this))
        ), $true
    )    
}

return $this.'.CommandMetadata'
