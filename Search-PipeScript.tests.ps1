describe Search-PipeScript {
    context 'Searching PowerShell' {
        it 'Can search for AST types within a ScriptBlock' {
            {
                "hello world $message"
            } | Search-PipeScript -AstType variable | 
                Select-Object -ExpandProperty Result |
                Should -Be '$message'
        }

        it 'Can search within an AST' {
            {
                "hello world $message"
            }.Ast |
                Search-PipeScript -AstType variable |
                Select-Object -ExpandProperty result |
                Should -Be '$message'
        }
    }

    context 'Searching text' {
        it 'Can search text, too' {
            '123' | 
                Search-PipeScript -RegularExpression '\d+' | 
                Select-Object -ExpandProperty Result |
                Should -Be '123'
        } 
    }
}
