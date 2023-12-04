param()

foreach ($place in $this.PrivateData, $this.PrivateData.PSData) {
    foreach ($potentialName in 'Route', 'Routes','Router','Routers') {
        $potentialRoutes = $place.$potentialName
        if (-not $potentialRoutes) { continue }

        foreach ($potentialRoute in $potentialRoutes) {
            $potentialRoute = 
                if ($potentialRoute -is [hashtable]) {                
                    $RouteObject = [Ordered]@{}
                    foreach ($sortedKeyValue in $place.$potentialName.GetEnumerator() | Sort-Object Key) {
                        $RouteObject[$sortedKeyValue.Key]= $sortedKeyValue.Value
                    }
                    $RouteObject = [PSCustomObject]$RouteObject                    
                } elseif ($potentialRoute) {
                    [PSObject]::new($potentialRoute)
                }
            $potentialRoute.pstypenames.clear()
            $potentialRoute.pstypenames.add("$this.Route")
            $potentialRoute.pstypenames.add('PipeScript.Module.Route')
            $potentialRoute
        }
    }
}