class VaultRef : IObject {
    [string] $Id
    [string] $Name

    VaultRef(){}

    VaultRef([pscustomobject] $Properties) : Base($Properties) {}
}
