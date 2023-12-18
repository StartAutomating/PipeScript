<#
.SYNOPSIS
    Returns the Value Of an object
.DESCRIPTION    
    valueOf allows you to override the returned value (in _some_ circumstances).

    Defining a member named `valueOf` will make .PSObject.valueOf return that member's value or result.

    Otherwise, `.valueOf()` will return the .ImmediateBaseObject.
.NOTES
    This makes .PSObject more similar to a JavaScript prototype.
#>
param()
$myName = 'valueOf'
if ($this.Members[$myName]) {
    if ($this.Properties[$myName]) {
        $this.Properties[$myName].Value
    }
    elseif ($this.Methods[$myName]) {
        $this.Methods[$myName].Invoke($args)
    }   
}
else {
    $this.ImmediateBaseObject
}