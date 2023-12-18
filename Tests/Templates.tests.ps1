describe 'PipeScript Templates' {
    context 'Template Files' {
        it 'Allows you to embed PipeScript in many file types' {
            @'
namespace TestProgram/*{Get-Random}*/ {
    public static class Program {
        public static string Hello() {
            string helloMessage = /*{param($n)
                if ($n) {
                    "`"hello $n`""
                } else {
                    '"hello"', '"hello world"', '"hey there"', '"howdy"' | Get-Random
                }
            }*/ string.Empty; 
            return helloMessage;
        }
    }
}    
'@ |
            Set-Content ".\HelloWorld.ps1.cs"
            $AddedFile = Invoke-PipeScript .\HelloWorld.ps1.cs
            $addedType = Add-Type -TypeDefinition (Get-Content $addedFile.FullName -Raw) -PassThru
            $addedType::Hello() | Should -belike 'H*'

            $addedFile2 = Invoke-PipeScript .\HelloWorld.ps1.cs 1
            $addedType2 = Add-Type -TypeDefinition (Get-Content $addedFile.FullName -Raw) -PassThru
            $addedType2::Hello() | Should -be 'Hello 1'

            Remove-Item .\HelloWorld.ps1.cs
            Remove-Item $AddedFile.FullName 
        }            
    }

    context 'Markdown' {
        it 'Can embed a value inline' {
            Invoke-PipeScript {
                $mdt = template a.md '`|{1}|`'
                $mdt.Evaluate()
            } | Should -be "1"
        }

        it 'Can embed a multiline value' {
            Invoke-PipeScript {
                $mdt = template a.md @'
~~~PipeScript{
"hello world"
}~~~
'@
                $mdt.Evaluate()
            } | Should -be 'Hello world'
        }

        it 'Can embed in an HTML comment' {
            Invoke-PipeScript {
                $mdt = template a.md '<!--{1}-->'
                $mdt.Evaluate()
            } | Should -be "1"
        }

        it 'Can embed in a CSS comment' {
            Invoke-PipeScript {
                $mdt = template a.md '/*{1}*/'
                $mdt.Evaluate()
            } | Should -be "1"
        }
    }        

    context 'JSON' {
        it 'Can embed JSON' {
            Invoke-PipeScript {
                $jsonTemplate = template my.json '/*{1}*/'
                $jsonTemplate.Evaluate()
            } | Should -be "1"
        }
        
        it 'Will turn non-string output into JSON' {
            Invoke-PipeScript {
                $jsonTemplate = template my.json '/*{Get-Process -id $pid | select name,id}*/'
                $jsonTemplate.Evaluate() 
            } | ConvertFrom-Json | 
                Select-Object -ExpandProperty Name | 
                Should -Be (Get-process -id $pid).Name
        }
    }    
}
