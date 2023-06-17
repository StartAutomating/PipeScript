
describe 'Update-PipeScript' {
    it 'Update-PipeScript Example 1' {
        Update-PipeScript -ScriptBlock {
            param($x,$y)
        } -RemoveParameter x
    }
    it 'Update-PipeScript Example 2' {
        Update-PipeScript -RenameVariable @{x='y'} -ScriptBlock {$x}
    }
    it 'Update-PipeScript Example 3' {
        Update-PipeScript -ScriptBlock {
            #region MyRegion
            1
            #endregion MyRegion
            2
        } -RegionReplacement @{MyRegion=''}
    }
}

