
describe 'Protocol.UDP' {
    it 'Protocol.UDP Example 1' {
    # Creates the code to create a UDP Client
    {udp://127.0.0.1:8568} | Use-PipeScript
    }
    it 'Protocol.UDP Example 2' {
    # Creates the code to broadast a message.
    {udp:// -Host [ipaddress]::broadcast -port 911 -Send "It's an emergency!"} | Use-PipeScript
    }
    it 'Protocol.UDP Example 3' {
    {send udp:// -Host [ipaddress]::broadcast -Port 911 "It's an emergency!"} | Use-PipeScript
    }
    it 'Protocol.UDP Example 4' {
    Use-PipeScript {
        watch udp://*:911
    
        send udp:// -Host [ipaddress]::broadcast -Port 911 "It's an emergency!"

        receive udp://*:911
    }
    }
}

