describe ValidateScriptBlock {
    it 'Can validates a ScriptBlock' {
        & ({
            [ValidateScriptBlock(DataLanguage)]
            $DataScriptBlock = { 1 }

            & $DataScriptBlock
        }.Transpile()) | Should -be 1
    }

    it 'Can ensure a ScriptBlock has no blocks' {
        & ({
            [ValidateScriptBlock(NoBlocks)]$Sb = { 1 }

            & $sb
        }.Transpile()) | Should -be 1

        {
            & ({
                [ValidateScriptBlock(NoBlocks)]$Sb = { process { 1 } }

                & $sb
            }.Transpile())
        } | Should -Throw
    }

    it 'Can ensure a ScriptBlock may only -IncludeCommand' {
        {
            & ({
                [ValidateScriptBlock(IncludeCommand='*-Process')]$Sb = { Get-Command }

                & $sb
            }.Transpile())
        } | Should -Throw
    }

    it 'Can ensure a ScriptBlock has -NoLoop' {
        {
            & ({
                [ValidateScriptBlock(NoLoop)]$Sb = { foreach ($n in 1..100) {$n} }

                & $sb
            }.Transpile())
        } | Should -Throw
    }

    it 'Can ensure a ScriptBlock has -NoWhileLoop' {
        {
            & ({
                [ValidateScriptBlock(NoLoop)]$Sb = { while (1) {$n} }

                & $sb
            }.Transpile())
        } | Should -Throw
    }
}
