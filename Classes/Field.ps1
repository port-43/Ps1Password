class Field : IObject {
    [string] $Id
    [string] $Label
    [nullable[FieldPurpose]] $Purpose
    [nullable[FieldType]] $Type
    [string] $Value
    [bool] $Generate
    [GeneratorRecipe] $Recipe
    [Section] $Section

    Field() {}

    Field([pscustomobject] $Properties) : Base($Properties) {}
}

enum FieldPurpose {
    USERNAME
    PASSWORD
    NOTES
}

enum FieldType {
    STRING
    EMAIL
    CONCEALED
    URL
    OTP
    DATE
    MONTH_YEAR
    MENU
}
