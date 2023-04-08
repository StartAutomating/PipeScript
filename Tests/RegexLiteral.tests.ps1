describe RegexLiteral {
    it 'Enables you write RegexLiterals in PipeScript' {
        {'/a|b/'} | .>Pipescript | Should -Be "[regex]::new('a|b', 'IgnoreCase')"
    }
    it 'Can turn expandable strings into RegExes' {
        {"/[$a$b]/"} | .>PipeScript | Should -Be '[regex]::new("[$a$b]", ''IgnoreCase'')'
    }
    context 'Potential pitfalls' {
        it 'Will not escape a single slash' {
            {'/'} | .>Pipescript | Should -Be "'/'"
        }
        it 'Will not process a RegexLiteral inside of an attribute' {
            {[Reflection.AssemblyMetadata('Key','/value/')]$v}.Transpile()
        }        
    }
}
