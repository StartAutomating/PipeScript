
describe 'Join-PipeScript' {
    it 'Join-PipeScript Example 1' {
        Get-Command Join-PipeScript | Join-PipeScript
    }
    it 'Join-PipeScript Example 2' {
        {param([string]$x)},
        {param([string]$y)} | 
            Join-PipeScript
    }
    it 'Join-PipeScript Example 3' {
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
    it 'Join-PipeScript Example 4' {
        {
            param($x = 1)
        } | Join-PipeScript -ExcludeParameter x
    }
}

