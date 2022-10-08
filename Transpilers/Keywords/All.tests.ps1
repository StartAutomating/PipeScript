describe all {
    context 'all is an iterator over everything' {
        it 'Can get all functions' {
            $allFunctions = @(& ({all functions}.Transpile()))
            
            $allFunctionInfos = @($allFunctions -as [Management.Automation.FunctionInfo[]])
            $allFunctionInfos.Length | Should -Be $allFunctions.Length            
        }

        it 'Can get all aliases' {
            $allAliases = @(& ({all aliases}.Transpile()))
            
            $allAliasInfos = @($allAliases -as [Management.Automation.AliasInfo[]])
            $allAliasInfos.Length | Should -Be $allAliases.Length
        }

        it 'Can get all applications' {
            $allApps = @(& ({all applications}.Transpile()))
            
            $allAppInfos = @($allApps -as [Management.Automation.ApplicationInfo[]])
            $allAppInfos.Length | Should -Be $allApps.Length
        }

        it 'Can get all variables' {
            $allVariables = @(& ({all variables}.Transpile()))
            
            $allPSVariables = @($allVariables)
            $allAppInfos.Length | Should -Be $allApps.Length
        }

        it 'Can get all things (variables, functions, filters, aliases)' {
            $allThings = @(& ({all things}.Transpile()))
            $allThings.Length | Should -BeGreaterThan 50
        }
    }

    it 'Can inject a typename' {
        function mallard([switch]$Quack) { $Quack }        
        . {all functions that quack are ducks}.Transpile()
        Get-Command mallard | 
            Get-Member  | 
            Select-Object -ExpandProperty TypeName -Unique |
            Should -be 'ducks'
    }

    it 'Can filter variables' {
        . {
            $numbers = 1..100
            all $numbers { ($_ % 2) -eq 1 } are odd
            all $numbers { ($_ % 2) -eq 0 } are even
        }.Transpile()
    
        @(
            . { all even $numbers }.Transpile()
        ).Length | Should -be 50
    
        @(
            . { all odd $numbers }.Transpile()
        ).Length | Should -be 50
    }
}