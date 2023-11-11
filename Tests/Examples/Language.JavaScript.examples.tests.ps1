
describe 'Language.JavaScript' {
    it 'Language.JavaScript Example 1' {
    $helloJs = Hello.js template '
    msg = null /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
    if (console) {
        console.log(msg);
    }
    '
    }
    it 'Language.JavaScript Example 2' {
    $helloMsg = {param($msg = 'hello world') "`"$msg`""}
    $helloJs = HelloWorld.js template "
    msg = null /*{$helloMsg}*/;
    if (console) {
        console.log(msg);
    }
    "
    }
}

