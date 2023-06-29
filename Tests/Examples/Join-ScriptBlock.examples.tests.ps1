
describe 'Join-ScriptBlock' {
    it 'Join-ScriptBlock Example 1' {
        Get-Command Join-PipeScript | Join-PipeScript
    }
    it 'Join-ScriptBlock Example 2' {
        {param([string]$x)},
        {param([string]$y)} | 
            Join-PipeScript |  Should -BeLike '*param(*$x,*$y*)*'
    }
    it 'Join-ScriptBlock Example 3' {
        {
            begin {
                $factor = 2
            }
        }, {
            process {
                $_ * $factor
            }
        } | Join-PipeScript
    }
    it 'Join-ScriptBlock Example 4' {
        {
            param($x = 1)
        } | Join-PipeScript -ExcludeParameter x
    }
}

