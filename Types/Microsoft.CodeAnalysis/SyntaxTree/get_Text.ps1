if (-not $this.'.Text') {    
    $this | Add-Member NoteProperty '.Text' $this.GetText([Threading.CancellationToken]::None) -Force    
}

$this.'.Text'
