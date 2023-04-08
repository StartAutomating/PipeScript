describe Await {
    it 'Lets us wait for asynchronous results' {
        Invoke-PipeScript -ScriptBlock {
            $webRequest    = new Net.HttpWebRequest "https://api.github.com/repos/StartAutomating/PipeScript"
            $awaitedResult = await $webRequest.GetResponseAsync()
            $awaitedResult | Should -not -be $null
        }
    }
}