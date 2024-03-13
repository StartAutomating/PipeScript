if ($this.Name -match '^(?>README|INDEX|HOME|DEFAULT)') {
    $this.Directory.Name -replace '[_-]', ' '
} else {
    $this.Name -replace '[_-]', ' ' -replace '\.md$'
}
