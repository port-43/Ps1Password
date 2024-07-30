@{
    # Script module or binary module file associated with this manifest
    RootModule = 'Ps1Password.psm1'

    # ID used to uniquely identify this module
    GUID = '7c6ff9ad-0bae-4fb7-b0dd-ea03dbb5ab7b'

    # Author of this module
    Author = 'Jeremiah Haywood (port-43)'

    # Copyright statement for this module
    Copyright = '(c) Jeremiah Haywood. All rights reserved.'

    # Version number of this module.
    ModuleVersion = '0.9.0'

    # Description of the functionality provided by this module
    Description = 'PowerShell module for interaction with 1Password Connector Server API'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '7.4'

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    ScriptsToProcess = @(
        '.\Classes\IObject',
        '.\Classes\Section',
        '.\Classes\File',
        '.\Classes\GeneratorRecipe',
        '.\Classes\Field',
        '.\Classes\Url',
        '.\Classes\ServiceDependency',
        '.\Classes\ServerHealth',
        '.\Classes\Vault',
        '.\Classes\VaultRef',
        '.\Classes\Item',
        '.\Classes\Request',
        '.\Classes\Ps1Password'
    )

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData      = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('1Password', 'powershell')

            # A URL to the license for this module.
            LicenseUri = 'https://raw.githubusercontent.com/port-43/Ps1Password/main/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/port-43/Ps1Password'
        }
    }
}
