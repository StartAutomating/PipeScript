[ValidatePattern('(^|\s)(?>Tech(?:nology)?|Jekyll)')]
param()


function Tech.Jekyll {

<#

    .SYNOPSIS
        Jekyll Tech Definition
    .DESCRIPTION
        Defines Jekyll as a techology PipeScript can work with.
    
        Jekyll is a simple, blog-aware, static site generator for personal, project, or organization sites.

        This allows PipeScript to generate, install, and serve Jekyll.
    
#>

$this = $myInvocation.MyCommand
if (-not $this.Instance) {
$singletonInstance = New-Module -ArgumentList @(@($input) + @($args)) -AsCustomObject {

    <#
    .SYNOPSIS
        Jekyll Tech Definition
    .DESCRIPTION
        Defines Jekyll as a techology PipeScript can work with.
    
        Jekyll is a simple, blog-aware, static site generator for personal, project, or organization sites.

        This allows PipeScript to generate, install, and serve Jekyll.
    #>
    param()
    $Name = 'Jekyll'
    $Synopsis = 'A simple, blog-aware, static site generator'
    $Description = @'
Jekyll is a simple, blog-aware, static site generator for personal, project, or organization sites.
'@
    $Website = 'https://jekyllrb.com/'
    $Compiler = 'jekyll','build'
    $Install = {gem install bundler jekyll}
    $Serve = 'jekyll','serve'
    $Language = 'Ruby'

Export-ModuleMember -Function * -Alias * -Cmdlet * -Variable *
}
$singletonInstance.pstypenames.clear()
$singletonInstance.pstypenames.add('Tech.Jekyll')
$singletonInstance.pstypenames.add('Tech')
Add-Member -InputObject $this -MemberType NoteProperty -Name Instance -Value $singletonInstance -Force
}
$this.Instance
    

}


