
describe 'Language.CSharp' {
    it 'Language.CSharp Example 1' {
        .> {
            $CSharpLiteral = '
    namespace TestProgram/*{Get-Random}*/ {
        public static class Program {
            public static void Main(string[] args) {
                string helloMessage = /*{
                    ''"hello"'', ''"hello world"'', ''"hey there"'', ''"howdy"'' | Get-Random
                }*/ string.Empty; 
                System.Console.WriteLine(helloMessage);
            }
        }
    }    
    '

            [OutputFile(".\HelloWorld.ps1.cs")]$CSharpLiteral
        }

        $AddedFile = .> .\HelloWorld.ps1.cs
        $addedType = Add-Type -TypeDefinition (Get-Content $addedFile.FullName -Raw) -PassThru
        $addedType::Main(@())
    }
}

