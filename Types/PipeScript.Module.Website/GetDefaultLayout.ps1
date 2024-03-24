param()

foreach ($potentialPropertyName in 'DefaultLayout','BaseLayout','Layout','Type') {
    if ($this.$potentialPropertyName) {
        return $this.$potentialPropertyName
    }
}

return $null
