param(
$ModuleName = 'PipeScript'
)

$moduleInfo = Get-Module $ModuleName
$commandsInModule = Get-Command -Module $moduleName 

$commandsWithExamples = $commandsInModule | Where-Object { $_.Examples }

$examplePattern = [Regex]::new('(?<ws>[\s\r\n]{0,})\#\sShould\s(?<C>.+?)$', 'Multiline,IgnoreCase,IgnorePatternWhitespace')

$testsDirectory = $moduleInfo | Split-Path | Join-Path -ChildPath Tests | Join-Path -ChildPath "Examples"

if (-not (Test-Path $testsDirectory)) {
    $null = New-Item -ItemType Directory -Path $testsDirectory
}

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

    $testFilePath = Join-Path $testsDirectory "$CommandShouldWork.examples.tests.ps1"
    $exampleFileContent | Set-Content $testFilePath
    Get-Item $testFilePath    
}
