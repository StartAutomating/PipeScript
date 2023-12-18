
describe 'PostProcess-LanguageDefinition' {
    it 'PostProcess-LanguageDefinition Example 1' {
        Import-PipeScript {         
            language function TestLanguage {
                $AnyVariableInThisBlock = 'Will Become a Property'
            }
        }
    }
}

