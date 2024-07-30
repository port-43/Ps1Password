class Vault : IObject {
    [string] $Id
    [string] $Name
    [Int] $AttributeVersion
    [Int] $ContentVersion
    [Int] $Items
    [VaultType] $Type
    [datetime] $CreatedAt
    [datetime] $UpdatedAt

    Vault(){}

    Vault([pscustomobject] $Properties) : Base($Properties) {}
}

enum VaultType {
    EVERYONE
    PERSONAL
    USER_CREATED
}
