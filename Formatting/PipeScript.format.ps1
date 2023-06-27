Write-FormatView -TypeName PipeScript -Property Name, Synopsis -Wrap

Write-FormatView -TypeName PipeScript -Property Name, Parameters -VirtualProperty @{
    Parameters = {        
        @(foreach ($kv in ([Management.Automation.CommandMetaData]$_).Parameters.GetEnumerator()) {
            @(
                Format-RichText -ForegroundColor Verbose -InputObject "[$($kv.Value.ParameterType)]"
                Format-RichText -ForegroundColor Warning -InputObject "`$$($kv.Key)"            
            ) -join ''
        }) -join [Environment]::NewLine
    }    
    Extends = {
        $_.Extends -join [Environment]::NewLine
    }
} -Wrap -Name Parameters
