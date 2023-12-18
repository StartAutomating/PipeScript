if (-not $this.'.Text') {    
    $this | Add-Member NoteProperty '.Text' $this.GetText() -Force    
}

$this.'.Text'
