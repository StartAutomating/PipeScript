<#
.SYNOPSIS
    Ensures Examples Work
.DESCRIPTION
    Ensures Examples work by turning each example into a test.

    Including a comment followed by 'should' will turn specific lines of the test into Pester should statements.
.NOTES
    This build is run condtionally, whenever the word "Example" is used in a commit message.
#>
[ValidatePattern(
    # In a PipeScript *.Build.ps1 file, ValidatePattern will be checked against the last commit message.
    # This checks for the Pattern:
    "Example"
    # If the pattern is found, then the script will run.
    # If the pattern is not found, then the script will not run (and this will be written as a warning and noted in the build summary)
)]
[Reflection.AssemblyMetadata(
    # Order impacts the order in which commands run.  A lower order will run sooner, a higher order will run later.
    # The default order is 0.
    "Order",
    1kb # by indicating an Order of 1kb, we are really saying "run later than most things"
)]
param(
# The name of the module containing examples
$ModuleName = 'PipeScript'
)

$moduleInfo = Get-Module $ModuleName

# Reload the module, because commands may have been created since this process first launched.
$psd1Path = $moduleInfo.Path -replace '\.psm1','.psd1'
if (Test-path $psd1Path) {
    Import-Module $psd1Path -Global -Force
}

$commandsInModule = Get-Command -Module $moduleName -CommandType All

$commandsWithExamples = $commandsInModule | Where-Object { $_.Examples }

$examplePattern = [Regex]::new('(?<ws>[\s\r\n]{0,})\#\s(?<P>.+?(?=\z|Should))?Should\s(?<C>.+?)$', 'IgnoreCase,IgnorePatternWhitespace', '00:00:05')

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
        try {
        "    it '$commandShouldWork Example $($exampleCounter)' {"
        
            $examplePattern.Replace($commandExample, ' | ${P} Should ${C}')
        "    }"
        } catch {
            $ex = $_
            # If for whatever reason the regex threw an exception, don't make a test out of this example.            
        }
    }
    "}"
    '') -join [Environment]::newLine

    $testFilePath = Join-Path $testsDirectory "$CommandShouldWork.examples.tests.ps1"
    $exampleFileContent | Set-Content $testFilePath
    Get-Item $testFilePath    
}
