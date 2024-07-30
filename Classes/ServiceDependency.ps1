class ServiceDependency : IObject {
    [string] $Service
    [string] $Status
    [string] $Message

    ServiceDependency() {}

    ServiceDependency([pscustomobject] $Properties) : Base($Properties) {}
}
