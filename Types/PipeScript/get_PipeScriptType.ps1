if ($this.Source -match '\.psx\.ps1{0,1}$') {
    "Transpiler"
}
elseif ($this.Source -match "\.ps1{0,1}\.(?<ext>[^.]+$)") {
    "SourceGenerator"
}
elseif ($this.Source) {
    "PipeScriptFile"
}
else {
    "Function"
}
