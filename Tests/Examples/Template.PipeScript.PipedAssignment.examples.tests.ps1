
describe 'Template.PipeScript.PipedAssignment' {
    it 'Template.PipeScript.PipedAssignment Example 1' {
        {
            $Collection |=| Where-Object Name -match $Pattern
        } | .>PipeScript

        # This will become:

        $Collection = $Collection | Where-Object Name -match $pattern
    }
    it 'Template.PipeScript.PipedAssignment Example 2' {
        {
            $Collection |=| Where-Object Name -match $pattern | Select-Object -ExpandProperty Name
        } | .>PipeScript

        # This will become

        $Collection = $Collection |
                Where-Object Name -match $pattern |
                Select-Object -ExpandProperty Name
    }
}

