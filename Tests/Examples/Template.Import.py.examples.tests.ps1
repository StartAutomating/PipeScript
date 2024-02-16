
describe 'Template.Import.py' {
    it 'Template.Import.py Example 1' {
        Template.Import.py -ModuleName sys
    }
    it 'Template.Import.py Example 2' {
        'sys','json' | Template.Import.py -As { $_[0] }
    }
}

