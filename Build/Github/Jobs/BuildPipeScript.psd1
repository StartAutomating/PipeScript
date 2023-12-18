@{
    "runs-on" = "ubuntu-latest"    
    if = '${{ success() }}'
    steps = @(
        @{
            name = 'Check out repository'
            uses = 'actions/checkout@v2'
        },
        @{
            name = 'GitLogger'
            uses = 'GitLogging/GitLoggerAction@main'
            id = 'GitLogger'
        },
        @{
            name = 'Use PSSVG Action'
            uses = 'StartAutomating/PSSVG@main'
            id = 'PSSVG'
        }, 
        'RunPiecemeal',
        @{
            name = 'Run PipeScript (from main)'
            if   = '${{github.ref_name == ''main''}}'
            uses = 'StartAutomating/PipeScript@main'
            id = 'PipeScriptMain'
        },
        @{
            name = 'Run PipeScript (on branch)'
            if   = '${{github.ref_name != ''main''}}'
            uses = './'
            id = 'PipeScriptBranch'
        },
        'RunEZOut',
        'RunHelpOut'
    )
}