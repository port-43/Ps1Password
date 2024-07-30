class Url : IObject {
    [string] $Label
    [bool] $Primary
    [uri] $Href

    Url() {}

    Url([pscustomobject] $Properties) : Base($Properties) {}
}
