function Get-1PasswordClient {
    <#
        .SYNOPSIS
        Retrieve the Ps1Password client

        .DESCRIPTION
        Retrieve the Ps1Password client

        .PARAMETER Token
        The access token to authenticate against the Connector Server API. Example: "$Token | ConvertTo-SecureString -AsPlaintext -Force"

        .PARAMETER ConnectServer
        The uri of the Connector Server API. Example: "http://192.168.1.87:8089"

        .EXAMPLE
        Get-1PasswordClient

        .EXAMPLE
        Get-1PasswordClient -Token $Token -ConnectServer 'http://192.168.1.87:8089'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'Ps1PasswordClient')]
        [securestring] $Token,

        [Parameter(Mandatory = $false, ParameterSetName = 'Ps1PasswordClient')]
        [string] $ConnectServer
    )
    process {
        if ($Global:Ps1PasswordClient) {
            return $Global:Ps1PasswordClient
        } else {
            if ($PSCmdlet.ParameterSetName -eq 'Ps1PasswordClient') {
                if ($null -like $Token -or $null -like $ConnectServer) {
                    throw "Ps1PasswordClient hasn't been initialized, must provide both token and connector server"
                }

                $Global:Ps1PasswordClient = [Ps1Password]::new($Token, $ConnectServer)
            }

            return $Global:Ps1PasswordClient
        }
    }
}
