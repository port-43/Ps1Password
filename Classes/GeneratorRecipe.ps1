using namespace System.Collections.Generic
class GeneratorRecipe : IObject {
    [Int] $Length
    [List[CharacterSets]] $CharacterSets = [List[CharacterSets]]::new()
    [string] $ExcludeCharacters

    GeneratorRecipe() {}

    GeneratorRecipe([pscustomobject] $Properties) : Base($Properties) {}
}

enum CharacterSets {
    LETTERS
    DIGITS
    SYMBOLS
}
