
function Template.HelloWorld.cs {

    <#
    .SYNOPSIS
        Hello World in CSharp
    .DESCRIPTION
        A Template for Hello World, in CSharp.    
    #>
    param(
    # The message to print.  By default, "hello world".
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Message = "hello world"
    )
    process {
@"
    public static class Program {
        public static void Main(string[] args) {
            string helloMessage = @"
$($Message.Replace('"','""'))
";
            if (args != null && args.Length > 0) {
                helloMessage = System.String.Join(" ", args);
            }
            System.Console.WriteLine(helloMessage);
        }
    }
"@
    }

}


