<#
.SYNOPSIS
    Validates an Object with a Script
.DESCRIPTION
    Validates one or more objects against the .ScriptBlock of this attribute.

    If the .ScriptBlock does not return "falsey" value (`$false, 0`), the validation will pass.

    If there are no arguments passed, this's ErrorMessage starts with `$`, then the values produced by that expression will be validated.
.EXAMPLE
    [ValidateScript]::new({$_ % 2}).Validate(1) # Should -Be $true
.EXAMPLE
    [ValidateScript]::new({$_ % 2}).Validate(0) # Should -Be $false
#>
param()

$allArguments = @($args | & { process { $_ } })

if ((-not $allArguments.Length) -and 
    ($this.ErrorMessage -notmatch '^\$')
) { return }
elseif (-not $allArguments.Length) {
    $allArguments = @(
        $ExecutionContext.SessionState.InvokeCommand.InvokeScript($this.ErrorMessage) | & { process { $_ } }
    )
}


# Validating a Script is mostly simple, except for one fairly large gotcha.
# In PowerShell, two wrongs ($false, $false) will be interpretered as $true
# So, we want want to correct for this "two wrongs make a right".
@(    
    @(
        # Run the validate script for every argument
        foreach ($argument in $allArguments) {
            $_ = $psItem = $argument
            try {
                . $this.ScriptBlock $argument | 
                . { process {
                    $_ -as [bool] # and quickly determine if each item is truthy
                } } 
            } catch {
                Write-Error -ErrorRecord $_
                $false
            }            
        }        
    ) -as # and force the whole thing into a list, which we see if we can make into 
    [bool[]] -eq # an array of booleans.
    $false # Then, PowerShell equality comparison will only return the $false items in the list
).Length -eq 0 # and if nothing is false, we're quite sure that two wrongs didn't make a right, and that our validation passed.





