$this -replace '(?>Magic|Automatic)\p{P}Variable\p{P}' -replace 
    '^(?>PowerShell|PipeScript)' -replace
    '^\p{P}' -replace '\p{P}$'
