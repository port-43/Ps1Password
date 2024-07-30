function Get-1PasswordFileDetails {
    <#
        .SYNOPSIS
        Retrieve details of a file

        .DESCRIPTION
        Retrieve details of a file

        .PARAMETER VaultUUID
        The UUID of the vault to get the details of. Example: "jzgmu4ie4delmx7excmgeeb7wz"

        .PARAMETER ItemUUID
        The UUID of the item to retrieve. Example: "q47aqw3sqmqgwcbphjxkjhjtpz"

        .PARAMETER FileUUID
        The UUID of the file to retrieve. Example: "gby2ovy2o5yyteid34ldf7fncx"

        .PARAMETER File
        A vault file object

        .PARAMETER Token
        The access token to authenticate against the Connector Server API. Example: "$Token | ConvertTo-SecureString -AsPlaintext -Force"

        .PARAMETER ConnectServer
        The uri of the Connector Server API. Example: "http://192.168.1.87:8089"

        .EXAMPLE
        Get-1PasswordFileDetails -VaultUUID "jzgmu4ie4delmx7excmgeeb7wz" -ItemUUID "q47aqw3sqmqgwcbphjxkjhjtpz" -FileUUID "gby2ovy2o5yyteid34ldf7fncx"

        .EXAMPLE
        Get-1PasswordFileDetails -File $File

        .EXAMPLE
        Get-1PasswordFileDetails -File $File -Token $Token -ConnectServer 'http://192.168.1.87:8089'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string] $VaultUUID,

        [Parameter(Mandatory = $false)]
        [string] $ItemUUID,

        [Parameter(Mandatory = $false)]
        [string] $FileUUID,

        [Parameter(Mandatory = $false)]
        [File] $File,

        [Parameter(Mandatory = $false, ParameterSetName = 'Ps1PasswordClient')]
        [securestring] $Token,

        [Parameter(Mandatory = $false, ParameterSetName = 'Ps1PasswordClient')]
        [string] $ConnectServer
    )
    begin {
        $1PasswordClient = Get-1PasswordClient -Token $Token -ConnectServer $ConnectServer
    }
    process {
        if ($File) {
            $1PasswordClient.GetFileDetails($File, $true)
        } else {
            $1PasswordClient.GetFileDetails($VaultUUID, $ItemUUID, $FileUUID, $true)
        }
    }
}
