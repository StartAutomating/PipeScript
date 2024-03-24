param(
[PSObject]
$Layout,

[PSObject]
$Parameter
)

if (-not $layout -or $layout -eq 'Default') {
    $Layout = $PSLanguage.HTML.Templates.'HTML.Default.Layout'
}

if ($layout -is [string]) {
    $Layout = $ExecutionContext.SessionState.InvokeCommand.GetCommand($layout, 'All')
}




if ($layout -is [Management.Automation.ApplicationInfo]) {
    $layoutArguments = @() + $Parameter
    & $layout @layoutArguments
} else {
    $paramSplat = [Ordered]@{}
    if ($parameter -isnot [Collections.IDictionary]) {
        if ($parameter -is [object[]]) {    
            foreach ($paramSet in $parameter) {
                if ($paramSet -isnot [Collections.IDictionary]) {                    
                    foreach ($paramProp in $paramSet.psobject.properties) {
                        $paramSplat[$paramProp.Name] = $paramProp.Value
                    }
                    $paramSet = $paramSplat
                } else {
                    foreach ($kvp in $paramSet.GetEnumerator()) {
                        $paramSplat[$kvp.Key] = $kvp.Value
                    }
                } 
            }            
        } else {
            
            foreach ($paramProp in $parameter.psobject.properties) {
                $paramSplat[$paramProp.Name] = $paramProp.Value
            }
        }
    } else {
        $paramSplat += $Parameter
    }

    if ($layout.Parameters) {
        :nextParameter foreach ($paramName in @($paramSplat.Keys)) {
            if (-not $layout.Parameters[$paramName]) {
                foreach ($layoutParameter in $layoutParameters.Values) {
                    if ($layoutParameter.Aliases -contains $paramName) {
                        continue nextParameter
                    }
                }
                Write-Verbose "Removing parameter $paramName from splat, since it is not a parameter of $layout."
                $paramSplat.Remove($paramName)
            }
        }
    }

    & $layout @paramSplat
}