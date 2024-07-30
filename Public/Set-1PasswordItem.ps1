function Set-1PasswordItem {
    <#
        .SYNOPSIS
        Replace a vault item

        .DESCRIPTION
        Replace a vault item

        .PARAMETER Item
        A vault Item object

        .PARAMETER Token
        The access token to authenticate against the Connector Server API. Example: "$Token | ConvertTo-SecureString -AsPlaintext -Force"

        .PARAMETER ConnectServer
        The uri of the Connector Server API. Example: "http://192.168.1.87:8089"

        .EXAMPLE
        Set-1PasswordItem -Item $Item

        .EXAMPLE
        Set-1PasswordItem -Item $Item -Token $Token -ConnectServer 'http://192.168.1.87:8089'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
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
        $1PasswordClient.ReplaceItem($Item)
    }
}
