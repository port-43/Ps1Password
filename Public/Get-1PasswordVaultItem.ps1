function Get-1PasswordVaultItem {
    <#
        .SYNOPSIS
        Retrieve a list of vault items

        .DESCRIPTION
        Retrieve a list of vault items

        .PARAMETER VaultUUID
        The UUID of the vault to get the details of. Example: "jzgmu4ie4delmx7excmgeeb7wz"

        .PARAMETER Token
        The access token to authenticate against the Connector Server API. Example: "$Token | ConvertTo-SecureString -AsPlaintext -Force"

        .PARAMETER ConnectServer
        The uri of the Connector Server API. Example: "http://192.168.1.87:8089"

        .EXAMPLE
        Get-1PasswordVaultItem -VaultUUID "jzgmu4ie4delmx7excmgeeb7wz"

        .EXAMPLE
        Get-1PasswordVaultItem -VaultUUID "jzgmu4ie4delmx7excmgeeb7wz" -Token $Token -ConnectServer 'http://192.168.1.87:8089'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $VaultUUID,

        [Parameter(Mandatory = $false, ParameterSetName = 'Ps1PasswordClient')]
        [securestring] $Token,

        [Parameter(Mandatory = $false, ParameterSetName = 'Ps1PasswordClient')]
        [string] $ConnectServer
    )
    begin {
        $1PasswordClient = Get-1PasswordClient -Token $Token -ConnectServer $ConnectServer
    }
    process {
        $1PasswordClient.ListVaultItems($VaultUUID)
    }
}
