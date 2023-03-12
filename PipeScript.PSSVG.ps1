#requires -Module PSSVG

$psChevron = Invoke-restMethod https://pssvg.start-automating.com/Examples/PowerShellChevron.svg
$RotateEvery = [Timespan]'00:01:30'

svg -ViewBox 1920,1080 @(
    svg.defs @(
        SVG.GoogleFont -FontName "Roboto"
        SVG.marker -id 'marker' -ViewBox 100,100 @(
            svg.polygon -Points (@(
                "30,0"
                "35,0"
                "60,50"
                "15,100"
                "12.5,100"
                "55,50"
            ) -join ' ') -Fill '#4488ff' -Class 'foreground-fill'
        ) -MarkerWidth 75 -MarkerHeight 75 -RefX 50 -RefY 50 -Orient 'auto-start-reverse'        
    )
    
    $psChevron.svg.symbol.OuterXml
    
    
    svg.text -FontSize 192 -TextAnchor 'middle' -DominantBaseline 'middle' -X 50% -Y 50% -Content @(
        SVG.tspan -Content "P" -FontSize 1em
        SVG.tspan -Content "|" -FontSize .66em -Dx -.33em
        SVG.tspan -Content "peScr" -FontSize 1em -Dx -.25em
        SVG.tspan -Content "|" -FontSize .66em -Dx -.33em
        SVG.tspan -Content "pt" -FontSize 1em -Dx -.25em
    ) -Style "font-family: 'Roboto', sans-serif" -Fill '#4488ff' -Class 'foreground-fill'

    
    
    
    $radius = 475
    $circleTop    = (1920/2), ((1080/2)-$radius)
    $circleMid    = (1920/2), (1080/2)
    $circleRight  = ((1920/2) + $radius),((1080/2))
    $circleBottom = (1920/2), ((1080/2)+$radius)
    $circleLeft   = ((1920/2) - $radius),((1080/2))
    SVG.ArcPath -Start $circleLeft -End $circleBottom -Sweep -Radius $radius -Large |
        SVG.ArcPath -Radius $radius -End $circleLeft -Sweep -Stroke '#4488ff' -Class foreground-stroke -fill transparent -markerEnd "url(#marker)" -strokeWidth 1.25 @(
            svg.animateTransform -AttributeName transform -From "360 $circleMid"  -To "0 $circleMid" -dur "$($RotateEvery.TotalSeconds)s" -RepeatCount 'indefinite' -AttributeType 'XML' -Type 'rotate'
        )

    SVG.ArcPath -Start $circleRight -End $circleTop -Sweep -Radius $radius -Large |
        SVG.ArcPath -Radius $radius -End $circleRight -Sweep -Stroke '#4488ff' -Class foreground-stroke -fill transparent -markerEnd "url(#marker)" -strokeWidth 1.25 @(
            svg.animateTransform -AttributeName transform -From "360 $circleMid"  -To "0 $circleMid" -dur "$($RotateEvery.TotalSeconds)s" -RepeatCount 'indefinite' -AttributeType 'XML' -Type 'rotate'
        )     
) -OutputPath (
    Join-Path $PSScriptRoot Assets | Join-Path -ChildPath "PipeScript.svg"
)