describe Update-PipeScript {
    context 'Updating ScriptBlocks' {
        it 'Can rename a variable' {
            Update-PipeScript -ScriptBlock { $v } -RenameVariable @{v='x'} |
                Should -BeLike '*$x*'
        }
    }

    context 'Updating text' {
        it 'Can -InsertBefore' {
            Update-PipeScript -ScriptBlock { "world" } -InsertBefore @{'world'= 'hello '} |
                Should -BeLike '*"hello world"*'
        }

        it 'Can -InsertAfter' {
            Update-PipeScript -ScriptBlock { "hello" } -InsertAfter @{"hello" = " world"} |
                Should -BeLike '*"hello world"*'
        }
    }
}
