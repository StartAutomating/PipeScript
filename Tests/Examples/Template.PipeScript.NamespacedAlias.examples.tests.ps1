
describe 'Template.PipeScript.NamespacedAlias' {
    it 'Template.PipeScript.NamespacedAlias Example 1' {
        . {
            PipeScript.Template alias .\Transpilers\Templates\*.psx.ps1
        }.Transpile()
    }
}

