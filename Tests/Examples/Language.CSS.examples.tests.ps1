
describe 'Language.CSS' {
    it 'Language.CSS Example 1' {
        .> {
            $StyleSheet = '
    MyClass {
        text-color: "#000000" /*{
    "''red''", "''green''","''blue''" | Get-Random
        }*/;
    }
    '
            [Save(".\StyleSheet.ps1.css")]$StyleSheet
        }

        .> .\StyleSheet.ps1.css
    }
}

