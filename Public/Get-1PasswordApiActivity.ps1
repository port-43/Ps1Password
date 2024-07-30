function Get-1PasswordApiActivity {
    <#
        .SYNOPSIS
        Retrieve a list of API Requests that have been made

        .DESCRIPTION
        Retrieve a list of API Requests that have been made

        .PARAMETER Token
        The access token to authenticate against the Connector Server API. Example: "$Token | ConvertTo-SecureString -AsPlaintext -Force"

        .PARAMETER ConnectServer
        The uri of the Connector Server API. Example: "http://192.168.1.87:8089"

        .EXAMPLE
        Get-1PasswordApiActivity

        .EXAMPLE
        Get-1PasswordApiActivity -Token $Token -ConnectServer 'http://192.168.1.87:8089'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'Ps1PasswordClient')]
        [securestring] $Token,

        [Parameter(Mandatory = $false, ParameterSetName = 'Ps1PasswordClient')]
        [string] $ConnectServer
    )
    begin {
        $1PasswordClient = Get-1PasswordClient -Token $Token -ConnectServer $ConnectServer
    }
    process {
        $1PasswordClient.ListApiActivity()
    }
}
