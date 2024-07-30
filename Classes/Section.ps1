class Section : IObject {
    [string] $Id
    [string] $Label

    Section() {}

    Section([pscustomobject] $Properties) : Base($Properties) {}
}
