
describe 'Language.Go' {
    it 'Language.Go Example 1' {
        Invoke-PipeScript {    
            HelloWorld.go template '
        package main

        import "fmt"
        func main() {
            fmt.Println("/*{param($msg = "hello world") "`"$msg`""}*/")
        }
        '
        }
    }
    it 'Language.Go Example 2' {
        Invoke-PipeScript {
        $HelloWorld = {param([Alias('msg')]$message = "Hello world") "`"$message`""}
        $helloGo = HelloWorld.go template "
        package main

        import `"fmt`"
        func main() {
            fmt.Println(`"/*{$helloWorld}*/`")
        }
        "

        $helloGo.Save()
        }
    }
    it 'Language.Go Example 3' {
        '
        package main
        import "fmt"
        func main() {
            fmt.Println("hello world")
        }
        ' | Set-Content .\HelloWorld.go

        Invoke-PipeScript .\HelloWorld.go
    }
}

