
describe 'Language.Perl' {
    it 'Language.Perl Example 1' {
    .> {
        $HelloWorldPerl = @'
=begin PipeScript
$msg = "hello", "hi", "hey", "howdy" | Get-Random
"print(" + '"' + $msg + '");'
=end   PipeScript
'@

        [Save(".\HelloWorld.ps1.pl")]$HelloWorldPerl
    }

    .> .\HelloWorld.ps1.pl
    }
}

