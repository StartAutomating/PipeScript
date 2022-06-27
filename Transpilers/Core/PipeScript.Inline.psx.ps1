<#
.Synopsis
    Inline Transpiler
.Description
    The PipeScript Core Inline Transpiler.  This makes Source Generators with inline PipeScript work.

    Regardless of underlying source language, a source generator works in a fairly straightforward way.

    Inline PipeScript will be embedded within the file (usually in comments).

    Anything encountered in a source generator file can be either:

    * A Literal String (written directly in the underlying source language)
    * A Script Block (written in PowerShell or PipeScript)

    This Transpiler takes a sequence of literal strings and script blocks, and constructs the source generation script.
#>
param(
# A list of source sections
[Parameter(Mandatory,ParameterSetName='SourceSections',Position=0,ValueFromPipeline)]
[PSObject[]]
$SourceSection,

# A string containing the text contents of the file
[Parameter(Mandatory,ParameterSetName='SourceTextAndPattern')]
[string]
$SourceText,

# A string containing the pattern used to recognize special sections of source code.
[Parameter(Mandatory,ParameterSetName='SourceTextAndPattern')]
[regex]
$SourcePattern,

# If set, will not transpile script blocks.
[Parameter(ParameterSetName='SourceTextAndPattern')]
[Parameter(ParameterSetName='SourceSections')]
[switch]
$NoTranspile,

# The path to the source file.
[Parameter(ParameterSetName='SourceTextAndPattern')]
[Parameter(ParameterSetName='SourceSections')]
[string]
$SourceFile,

# A Script Block that will be injected before each inline is run. 
[Parameter(ParameterSetName='SourceTextAndPattern')]
[Parameter(ParameterSetName='SourceSections')]
[ScriptBlock]
$Begin,

# A Script Block that will be piped to after each output.
[Parameter(ParameterSetName='SourceTextAndPattern')]
[Parameter(ParameterSetName='SourceSections')]
[Alias('Process')]
[ScriptBlock]
$ForeachObject,

# A Script Block that will be injected after each inline script is run. 
[Parameter(ParameterSetName='SourceTextAndPattern')]
[Parameter(ParameterSetName='SourceSections')]
[ScriptBlock]
$End
)

begin {
    $allSections = @()
}

process {
    if ($psCmdlet.ParameterSetName -eq 'SourceTextAndPattern') {

        $fileText      = $SourceText        
        $foundSpots    = @($SourcePattern.Matches($fileText))

        $SourceGeneratorInput = @(
            $index = 0                                    
            for ($spotIndex = 0; $spotIndex -lt $foundSpots.Count; $spotIndex++) {

                # If there's any distance between the last token and here, output it as a string.
                if ($foundSpots[$spotIndex].Index -gt $index) {
                    $captureLength    = $foundSpots[$spotIndex].Index - $index
                    if ($captureLength -ge 0) {
                        $fileText.Substring($index, $captureLength)                
                    }
                    $index = $foundSpots[$spotIndex].Index + $foundSpots[$spotIndex].Length
                }

                $isLastSpot = $spotIndex -ge ($foundSpots.Length - 1)

                if ($foundSpots[$spotIndex].Groups["PSStart"].Length) {
                    $absoluteStart = $foundSpots[$spotIndex].Groups["PSStart"].Index + 
                        $foundSpots[$spotIndex].Groups["PSStart"].Length 

                    $index = $foundSpots[$spotIndex + 1].Index + 
                        $foundSpots[$spotIndex + 1].Length
                    if (-not $isLastSpot -and $foundSpots[$spotIndex + 1].Groups["PSEnd"].Length) {
                        # If we find an end block, the next section becomes code
                                                
                        $scriptToCreate = @(
                            if ($Begin) { $Begin }
                            $AddForeach =
                                $(
                                    if ($ForeachObject) {
                                        '|' + [Environment]::NewLine
                                        @(foreach ($foreachStatement in $ForeachObject) {
                                            if ($foreachStatement.Ast.ProcessBlock -or $foreachStatement.Ast.BeginBlock) {
                                                ". {$ForeachStatement}"
                                            } elseif ($foreachStatement.Ast.EndBlock.Statements -and 
                                                $foreachStatement.Ast.EndBlock.Statements[0].PipelineElements[0].CommandElements -and
                                                $foreachStatement.Ast.EndBlock.Statements[0].PipelineElements[0].CommandElements.Value -in 'Foreach-Object', '%') {
                                                "$ForeachStatement"
                                            } else {
                                                "Foreach-Object {$ForeachStatement}"
                                            }
                                        }) -join (' |' + [Environment]::NewLine)
                                    }
                                )
                            $Statement = $fileText.Substring($absoluteStart, 
                                $index - $absoluteStart - $foundSpots[$spotIndex + 1].Groups["PSEnd"].Length
                            )
                            if ($AddForeach) {
                                "@($Statement)" + $AddForeach.Trim()
                            } else {
                                $Statement
                            }
                            
                            if ($End) { $end}
                            ) -join [Environment]::Newline
                        [scriptblock]::Create($scriptToCreate)
                        
                        $spotIndex++                
                    } else {
                        Write-Error "Start Not Followed By End' $($foundSpots[$spotIndex].Index)'"    
                    }
                }            
            }

            if ($index -lt $fileText.Length) {
                $fileText.Substring($index)            
            }
        )

        $null = $PSBoundParameters.Remove("SourceText")
        $null = $PSBoundParameters.Remove("SourcePattern")
        
        & $myInvocation.MyCommand.ScriptBlock @PSBoundParameters -SourceSection $SourceGeneratorInput
        return
    }

    $allSections += @(
    foreach ($section in $SourceSection) {
        
        if ($section -is [string]) {
            if ($section -match '[\r\n]') {
                "@'" + [Environment]::NewLine + $section + [Environment]::newLine + "'@"
            } else {
                "'" + $section.Replace("'", "''") + "'"
            }
        }

        if ($section -is [ScriptBlock]) {
            if (-not $NoTranspile) {
                $section | 
                    .>Pipescript
            } else {
                $section
            }
        }

    })
}

end {
    if ($allSections) {
        
        $combinedSections = @(for ($sectionIndex = 0 ; $sectionIndex -lt $allSections.Length; $sectionIndex++) {
            $section = $allSections[$sectionIndex]
            $isLastSection = $sectionIndex -eq $allSections.Length - 1
            if ($section -is [ScriptBlock]) {
                "`$($section)"
            } else {
                $section
            }
            if (-not $isLastSection) {
                '+'
            }
        })
        $combinedFile = $combinedSections -join ' '

        if ($SourceFile -and $SourceFile -match '\.ps1{0,1}\.(?<ext>[^.]+$)') {
            $sourceTempFilePath = $SourceFile -replace '\.ps1{0,1}\.(?<ext>[^.]+$)', '.${ext}.source.ps1'
            $combinedFile | Set-Content $sourceTempFilePath -Force
        }

        
        try {
            [scriptblock]::Create($combinedFile)
        } catch {
            $ex = $_       
            Write-Error -ErrorRecord $ex
        }
    }
}