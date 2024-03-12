<#
.Synopsis
    Tests if an IP is a local Intranet connection
.Description
    Determines if the remote connection is coming from within a local Intranet environment or not.
#> 
param()

$IP = $this

if (-not $IP) { return $false}

$addressBytes = $IP.GetAddressBytes()
if ($addressBytes.Count -eq 16) {
    return $IP.IsIPv6LinkLocal -or $IP.IsIPv6SiteLocal -or "$IP" -eq "::1"
} else {
    if ($addressBytes.Count -eq 4) {
        if ($addressBytes[0] -eq 10) {
            return $true
        } elseif ($addressBytes[0] -eq 172 -and $addressBytes[1] -ge 16 -and $addressBytes[1] -le 31) {
            return $true
        } elseif ($addressBytes[0] -eq 192 -and $addressBytes[1] -eq 168) {
            return $true
        } elseif ("$IP" -eq "127.0.0.1") {
            return $true
        }   
    }
}

return $false

