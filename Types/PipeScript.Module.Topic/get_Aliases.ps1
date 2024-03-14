@(
    ($this.Name -replace '[_-]', ' ' -replace '\.md$')
    if ($this.Metadata.Alias) {
        $this.Metadata.Alias -replace '[_-]', ' '
    }    
    if ($this.Metadata.Aliases) {
        $this.Metadata.Aliases -replace '[_-]', ' '
    }    
)