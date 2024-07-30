function Remove-1PasswordItem {
    <#
        .SYNOPSIS
        Delete a vault item

        .DESCRIPTION
        Delete a vault item

        .PARAMETER VaultUUID
        The UUID of the vault to retrieve the item from. Example: "jzgmu4ie4delmx7excmgeeb7wz"

        .PARAMETER ItemUUID
        The UUID of the item to delete. Example: "q47aqw3sqmqgwcbphjxkjhjtpz"

        .PARAMETER Item
        A vault Item object

        .PARAMETER Token
        The access token to authenticate against the Connector Server API. Example: "$Token | ConvertTo-SecureString -AsPlaintext -Force"

        .PARAMETER ConnectServer
        The uri of the Connector Server API. Example: "http://192.168.1.87:8089"

        .EXAMPLE
        Remove-1PasswordItem -VaultUUID "jzgmu4ie4delmx7excmgeeb7wz" -ItemUUID "q47aqw3sqmqgwcbphjxkjhjtpz"

        .EXAMPLE
        Remove-1PasswordItem -Item $Item

        .EXAMPLE
        Remove-1PasswordItem -Item $Item -Token $Token -ConnectServer 'http://192.168.1.87:8089'
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
            $1PasswordClient.DeleteItem($Item)
        } else {
            $1PasswordClient.DeleteItem($VaultUUID, $ItemUUID)
        }
    }
}
