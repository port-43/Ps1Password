using namespace System.Collections.Generic
class Item : IObject {
    [string] $Id
    [string] $Title
    [VaultRef] $Vault
    [ItemCategory] $Category
    [List[Url]] $Urls = [List[Url]]::new()
    [bool] $Favorite
    [List[string]] $Tags = [List[string]]::new()
    [Field[]] $Fields
    [List[Section]] $Sections = [List[Section]]::new()
    [List[File]] $Files = [List[File]]::new()
    [Int] $Version
    [nullable[datetime]] $CreatedAt
    [nullable[datetime]] $UpdatedAt
    [string] $LastEditedBy
    [string] $AdditionalInformation

    Item() {}

    Item([pscustomobject] $Properties) : Base($Properties) {}
}

enum ItemCategory {
    LOGIN
    PASSWORD
    API_CREDENTIAL
    SERVER
    DATABASE
    CREDIT_CARD
    MEMBERSHIP
    PASSPORT
    SOFTWARE_LICENSE
    OUTDOOR_LICENSE
    SECURE_NOTE
    WIRELESS_ROUTER
    BANK_ACCOUNT
    DRIVER_LICENSE
    IDENTITY
    REWARD_PROGRAM
    DOCUMENT
    EMAIL_ACCOUNT
    SOCIAL_SECURITY_NUMBER
    MEDICAL_RECORD
    SSH_KEY
}

enum ItemFilter {
    title
    tag
}
