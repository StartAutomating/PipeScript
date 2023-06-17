param(
$ModuleName = 'PipeScript'
)

$moduleInfo = Get-Module $ModuleName
$commandsInModule = Get-Command -Module $moduleName 

$commandsWithExamples = $commandsInModule | Where-Object { $_.Examples }

$examplePattern = [Regex]::new('(?<ws>[\s\r\n]{0,})\#\sShould\s(?<C>.+?)$', 'Multiline,IgnoreCase,IgnorePatternWhitespace')

$testsDirectory = Split-Path $PSScriptRoot | Split-Path | Join-Path -ChildPath Tests

foreach ($commandShouldWork in $commandsWithExamples) {
    $exampleCounter = 0
    $exampleFileContent = 
    @(
    ''
    "describe '$($commandShouldWork)' {"
    foreach ($commandExample in $commandShouldWork.Examples) {
        $exampleCounter++
        "    it '$commandShouldWork Example $($exampleCounter)' {"
            $examplePattern.Replace($commandExample, ' | Should ${C}')    
        "    }"
    }
    "}"
    '') -join [Environment]::newLine

    $testFilePath = Join-Path $testsDirectory "examples-$CommandShouldWork.tests.ps1"
    $exampleFileContent | Set-Content $testFilePath
    Get-Item $testFilePath    
}
