class Request : IObject {
    [guid] $RequestId
    [datetime] $Timestamp
    [string] $Action
    [string] $Result
    [pscustomobject] $Actor
    [pscustomobject] $Resource

    Request() {}

    Request([pscustomobject] $Properties) : Base($Properties) {}
}
