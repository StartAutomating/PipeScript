if ($this.'.Root') {
    return $this.'.Root'
}

$nextRoot = $this.Source | Split-Path
:findingRoot do {
    
    $lastRoot = $nextRoot
    $lastRootName = $lastRoot | Split-Path -Leaf

    if ($lastRootName -as [Version]) {
        $lastRootName = $lastRoot | Split-Path | Split-Path -Leaf
    }

    foreach ($fileNameThatIndicatesRoot in 'LICENSE', 'LICENSE.txt', 
        "$LastRootName.psd1", "$LastRootName.psm1", ".git") {
        $lookingForPath = Join-Path $lastRoot $fileNameThatIndicatesRoot
        if (Test-Path $lookingForPath) {
            break findingRoot
        }
    }

    $nextRoot = $nextRoot | Split-Path
} while ($nextRoot)

$this | Add-Member NoteProperty '.Root' "$lastRoot" -Force
$this.'.Root'