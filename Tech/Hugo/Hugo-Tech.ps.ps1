Tech Constant Hugo {
    <#
    .SYNOPSIS
        Hugo Tech Definition
    .DESCRIPTION
        Defines Hugo as a techology PipeScript can work with.                    
    #>
    param()
    $Name = 'Hugo'
    $Synopsis = 'A Fast and Flexible Static Site Generator'
    $Description = @'
Hugo is one of the most popular open-source static site generators. With its amazing speed and flexibility, Hugo makes building websites fun again.
'@
    $Website = 'https://gohugo.io/'
    $Install = {
        if ($IsMacOS) {brew install hugo} 
        elseif ($IsLinux) { sudo snap install hugo } 
        elseif (
            $executionContext.SessionState.InvokeCommand.GetCommand('choco','Application,Alias')
        )
            {choco install hugo-extended}
        elseif (
            $executionContext.SessionState.InvokeCommand.GetCommand('scoop','Application,Alias')
        )
            {scoop install hugo}
        elseif (
            $executionContext.SessionState.InvokeCommand.GetCommand('winget','Application,Alias')
        )
            {winget install Hugo.Hugo.Extended}
        else {
            'https://gohugo.io/download/'
        }
    }
    $Serve = {hugo server @args}
    $Language = 'Go'
}
