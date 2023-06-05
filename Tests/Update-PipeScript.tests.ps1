describe Update-PipeScript {
    context 'Updating ScriptBlocks' {
        it 'Can rename a variable' {
            Update-PipeScript -ScriptBlock { $v } -RenameVariable @{v='x'} |
                Should -BeLike '*$x*'
        }

        it 'Can remove a region' {
            Update-ScriptBlock {
                #region Before
                Before
                #endregion Before
                #region After
                After
                #endregion After
            } -ReplaceRegion @{"Before"= ""} | Should -BeLike *after*
        }

        it 'Can replace an AST element' {
            $scriptBlock = {
                # $x
                $x
            }
            $varAst = $scriptBlock.Ast.EndBlock.Statements[0].PipelineElements[0].Expression
            Update-ScriptBlock -AstReplacement @{
                $varAst = {$y}
            } -ScriptBlock $scriptBlock | Should -BeLike '*#*$x*$y*'

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

            Update-PipeScript -ScriptBlock { dynamicParam { hello } end { } } -Append { goodbye } | Should -BeLike '*dynamicParam*{*hello*}*end*{*goodbye*}*'
        }

        it 'Can -InsertBlockStart' {
            $testScriptBlock =  { "world" }
            $testStringExpression = $testScriptBlock.Ast.EndBlock.Statements[0].PipelineElements[0].Expression
            $testScriptBlock | Update-PipeScript -InsertBlockStart @{$testStringExpression= {"hello"}} | Should -BeLike "*hello*world*"
        }

        it 'Can -InsertBlockEnd' {
            $testScriptBlock =  { "hello" }
            $testStringExpression = $testScriptBlock | Search-PipeScript -AstType *String* | Select-Object -ExpandProperty Result
            $testScriptBlock | Update-PipeScript -InsertBlockEnd @{$testStringExpression= {"world"}} | Should -BeLike "*hello*world*"
        }
    }    
}
