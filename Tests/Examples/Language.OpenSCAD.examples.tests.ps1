
describe 'Language.OpenSCAD' {
    it 'Language.OpenSCAD Example 1' {
    .> {
        $OpenScadWithInlinePipeScript = @'
Shape = "cube" /*{'"cube"', '"sphere"', '"circle"' | Get-Random}*/;
Size  = 1 /*{Get-Random -Min 1 -Max 100}*/ ;

if (Shape == "cube") {
    cube(Size);
}
if (Shape == "sphere") {
    sphere(Size);
}
if (Shape == "circle") {
    circle(Size);
}
'@

        [OutputFile(".\RandomShapeAndSize.ps1.scad")]$OpenScadWithInlinePipeScript
    }
    
    .> .\RandomShapeAndSize.ps1.scad
    }
}

