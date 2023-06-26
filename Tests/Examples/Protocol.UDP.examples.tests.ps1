
describe 'Protocol.UDP' {
    it 'Protocol.UDP Example 1' {
    udp://127.0.0.1:8568  # Creates a UDP Client
    }
    it 'Protocol.UDP Example 2' {
    udp:// -Host [ipaddress]::broadcast -port 911 -Send "It's an emergency!"
    }
    it 'Protocol.UDP Example 3' {
    {send udp:// -Host [ipaddress]::broadcast -Port 911 "It's an emergency!"} | Use-PipeScript
    }
    it 'Protocol.UDP Example 4' {
    Invoke-PipeScript { watch udp://*:911 } 
    Invoke-PipeScript { send udp:// -Host [ipaddress]::broadcast -Port 911 "It's an emergency!" }
    Invoke-PipeScript { receive udp://*:911 }
    }
}

