function Get-1PasswordFile {
    <#
        .SYNOPSIS
        Retrieve a list of files for a specific vault item

        .DESCRIPTION
        Retrieve a list of files for a specific vault item

        .PARAMETER VaultUUID
        The UUID of the vault to get the details of. Example: "jzgmu4ie4delmx7excmgeeb7wz"

        .PARAMETER ItemUUID
        The UUID of the item to retrieve. Example: "q47aqw3sqmqgwcbphjxkjhjtpz"

        .PARAMETER Item
        A vault item object

        .PARAMETER Token
        The access token to authenticate against the Connector Server API. Example: "$Token | ConvertTo-SecureString -AsPlaintext -Force"

        .PARAMETER ConnectServer
        The uri of the Connector Server API. Example: "http://192.168.1.87:8089"

        .EXAMPLE
        Get-1PasswordFile -VaultUUID "jzgmu4ie4delmx7excmgeeb7wz" -ItemUUID "q47aqw3sqmqgwcbphjxkjhjtpz"

        .EXAMPLE
        Get-1PasswordFile -Item $Item

        .EXAMPLE
        Get-1PasswordFile -Item $Item -Token $Token -ConnectServer 'http://192.168.1.87:8089'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string] $VaultUUID,

        [Parameter(Mandatory = $false)]
        [string] $ItemUUID,

        [Parameter(Mandatory = $false)]
        [Item] $Item,

        [Parameter(Mandatory = $false, ParameterSetName = 'Ps1PasswordClient')]
        [securestring] $Token,

        [Parameter(Mandatory = $false, ParameterSetName = 'Ps1PasswordClient')]
        [string] $ConnectServer
    )
    begin {
        $1PasswordClient = Get-1PasswordClient -Token $Token -ConnectServer $ConnectServer
    }
    process {
        if ($Item) {
            $1PasswordClient.ListFiles($Item, $true)
        } else {
            $1PasswordClient.ListFiles($VaultUUID, $ItemUUID, $true)
        }
    }
}
