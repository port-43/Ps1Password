using namespace System.Collections.Generic
class ServerHealth : IObject {
    [string] $Name
    [string] $Version
    [List[ServiceDependency]] $Dependencies = [List[ServiceDependency]]::new()

    ServerHealth() {}

    ServerHealth([pscustomobject] $Properties) : Base($Properties) {}
}
