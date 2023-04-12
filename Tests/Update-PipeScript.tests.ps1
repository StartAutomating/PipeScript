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

        it 'Can -Prepend' {
            Update-PipeScript -ScriptBlock { goodbye } -Prepend { hello } | Should -BeLike '*hello*goodbye*'

            Update-PipeScript -ScriptBlock { dynamicParam { goodbye } } -Prepend { hello } | Should -BeLike '*dynamicParam*{*hello*goodbye*}*'

            Update-PipeScript -ScriptBlock { begin { goodbye } } -Prepend { hello } | Should -BeLike '*begin*{*hello*goodbye*}*'
            
            Update-PipeScript -ScriptBlock { process { goodbye } } -Prepend { hello } | Should -BeLike '*process*{*hello*goodbye*}*'
        }

        it 'Can -Append' {
            Update-PipeScript -ScriptBlock { hello } -Append { goodbye } | Should -BeLike '*hello*goodbye*'

            Update-PipeScript -ScriptBlock { dynamicParam { hello } } -Append { goodbye } | Should -BeLike '*dynamicParam*{*hello*goodbye*}*'

            Update-PipeScript -ScriptBlock { dynamicParam { hello } end { } } -Append { goodbye } | Should -BeLike '*dynamicParam*{*hello*goodbye*}*'
        }
    }
}
