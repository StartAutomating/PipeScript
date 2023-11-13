
describe 'Language.JavaScript' {
    it 'Language.JavaScript Example 1' {
    Invoke-PipeScript {
        Hello.js template '
        msg = null /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
        if (console) {
            console.log(msg);
        }
        '
        
    }
    }
    it 'Language.JavaScript Example 2' {
    Invoke-PipeScript {
        $helloMsg = {param($msg = 'hello world') "`"$msg`""}
        $helloJs = HelloWorld.js template "
        msg = null /*{$helloMsg}*/;
        if (console) {
            console.log(msg);
        }
        "
        $helloJs
    }
    }
    it 'Language.JavaScript Example 3' {
    "console.log('hi')" > .\Hello.js
    Invoke-PipeScript .\Hello.js
    }
}

