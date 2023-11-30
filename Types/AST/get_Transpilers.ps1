$scriptText = $this.Extent.ToString()

# If the ScriptBlock had attributes, we'll add them to a special list of things that will be transpiled first.
    
# Find all AST elements within the script block.
$astList = @($this.FindAll({$true}, $false))

# At various points within transpilation, we will be skipping processing until a known end pointer.  For now, set this to null.
$skipUntil  = 0
# Keep track of the offset from a starting position as well, for the same reason.
$myOffset   = 0

# Walk over each item in the abstract syntax tree.
:NextAstItem foreach ($item in $astList) {
    # If skipUntil was set,
    if ($skipUntil) {
        # find the space between now and the last known offset.
        try {
            $newOffset = $scriptText.IndexOf($item.Extent.Text, $myOffset)
            if ($newOffset -eq -1) { continue }
            $myOffset  = $newOffset
        } catch {
            $ex =$_
            $null = $null
        }
        if ($myOffset -lt $skipUntil) { # If this is before our skipUntil point
            continue # ignore this AST element.
        }
        $skipUntil = $null # If we have reached our skipUntil point, let's stop skipping.
    }
    # otherwise, find if any pipescripts match this AST

    $foundTranspilers = Get-Transpiler -CouldPipe $item -ValidateInput $item 

    if ($foundTranspilers) {
        foreach ($transpiler in $foundTranspilers) {
            [PSCustomObject][Ordered]@{
                PSTypeName = 'PipeScript.Transpiler.Location'
                Transpiler = 
                    if ($Transpiler.ExtensionInputObject.ResolvedCommand) {
                        @($Transpiler.ExtensionInputObject.ResolvedCommand) -ne $null
                    } else {
                        $Transpiler.ExtensionCommand
                    }
                AST = $item
            }
        }
        
        $start = $scriptText.IndexOf($item.Extent.Text, $myOffset) # determine the end of this AST element
        $end   = $start + $item.Extent.Text.Length
        $skipUntil = $end # set SkipUntil
    }
}