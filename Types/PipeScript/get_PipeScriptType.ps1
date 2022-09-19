if ($this.Source -match '\.psx\.ps1{0,1}$') {
    "Transpiler"
}
elseif ($this.Source -match "\.ps1{0,1}\.(?<ext>[^.]+$)") {
    "SourceGenerator"
}
elseif (($this.Source -match '\.[^\.\\/]+\.ps1$') -or ($this.Source -match 'build\.ps1$')) {
    "BuildScript"
}
elseif ($this.Source) {
    "PipeScriptFile"
}
else {
    "Function"
}
