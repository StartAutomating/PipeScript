$parameter = $this
$parameterIndex = $parameter.Parent.Parameters.IndexOf($this)

if ($parameterIndex -eq 0) { # For the first parameter
    $parentExtent = $parameter.Parent.Extent.ToString()
    # This starts after the first parenthesis. 
    $afterFirstParens = $parentExtent.IndexOf('(') + 1
    # and goes until the start of the parameter.
    $parentExtent.Substring($afterFirstParens, 
        $parameter.Extent.StartOffset - 
            $parameter.Parent.Extent.StartOffset - 
                $afterFirstParens) -replace '^[\s\r\n]+'
    # (don't forget to trim leading whitespace)
} else {
    # for every other parameter it is the content between parameters.
    $lastParameter   = $parameter.Parent.Parameters[$parameterIndex - 1]                                    
    $relativeOffset  = $lastParameter.Extent.EndOffset + 1 - $parameter.Parent.Extent.StartOffset
    $distance        = $parameter.Extent.StartOffset - $lastParameter.Extent.EndOffset - 1
    # (don't forget to trim leading whitespace and commas)
    $parameter.Parent.Extent.ToString().Substring($relativeOffset,$distance) -replace '^[\,\s\r\n]+'
}