<#
.SYNOPSIS
    Gets Module EntryPoints
.DESCRIPTION
    Gets any EntryPoints associated with a module.

    EntryPoints describe the command that should be run when the module is launched (ideally in a container).

    EntryPoints can be defined within a module's `.PrivateData` or `.PrivateData.PSData`
#>
param()

foreach ($moduleEntryPoint in $this.FindMetadata('EntryPoint', 'EntryPoints')) {        
    if ($moduleEntryPoint) {
        $moduleEntryPoint.pstypenames.clear()
        $moduleEntryPoint.pstypenames.add("$this.EntryPoint")
        $moduleEntryPoint.pstypenames.add('PipeScript.Module.EntryPoint')
        Add-Member -InputObject $moduleEntryPoint -Name Module -Value $this -Force -MemberType NoteProperty
        $moduleEntryPoint
    }
}
