Describe 'New-PipeScript' {
    It 'Parameter Syntax Supports Help String' {
        {
            New-PipeScript -Parameter @{
                'bar' = @{
                    Name       = 'foo'
                    Help       = 'Foobar'
                    Attributes = 'Mandatory', 'ValueFromPipelineByPropertyName'
                    Aliases    = 'fubar'
                    Type       = 'string'
                }
            }
        } | Should -Not -Throw
    }
}
