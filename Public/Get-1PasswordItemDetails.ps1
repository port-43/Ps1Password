function Get-1PasswordItemDetails {
    <#
        .SYNOPSIS
        Retrieve item details

        .DESCRIPTION
        Retrieve item details

        .PARAMETER VaultUUID
        The UUID of the vault to get the details of. Example: "jzgmu4ie4delmx7excmgeeb7wz"

        .PARAMETER ItemUUID
        The UUID of the item to retrieve. Example: "q47aqw3sqmqgwcbphjxkjhjtpz"

        .PARAMETER Item
        A vault Item object

        .PARAMETER Token
        The access token to authenticate against the Connector Server API. Example: "$Token | ConvertTo-SecureString -AsPlaintext -Force"

        .PARAMETER ConnectServer
        The uri of the Connector Server API. Example: "http://192.168.1.87:8089"

        .EXAMPLE
        Get-1PasswordItemDetails -VaultUUID "jzgmu4ie4delmx7excmgeeb7wz" -ItemUUID "q47aqw3sqmqgwcbphjxkjhjtpz"

        .EXAMPLE
        Get-1PasswordItemDetails -Item $Item

        .EXAMPLE
        Get-1PasswordItemDetails -Item $Item -Token $Token -ConnectServer 'http://192.168.1.87:8089'
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
            $1PasswordClient.GetItemDetails($Item)
        } else {
            $1PasswordClient.GetItemDetails($VaultUUID, $ItemUUID)
        }
    }
}
