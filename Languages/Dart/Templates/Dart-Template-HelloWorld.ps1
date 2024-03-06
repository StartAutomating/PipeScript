[ValidatePattern("Dart")]
param()


function Template.HelloWorld.dart {

    <#
    .SYNOPSIS
        Hello World in Dart
    .DESCRIPTION
        A Template for Hello World, in Dart.    
    #>
    param(
    # The message to print.  By default, "hello world".
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Message = "hello world"
    )
    process {
@"
void main() {
    print('$Message');
}
"@
    }

}


