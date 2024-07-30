function Set-1PasswordItemAttribute {
    <#
        .SYNOPSIS
        Retrieve item details

        .DESCRIPTION
        Retrieve item details

        .PARAMETER VaultUUID
        The UUID of the vault the item is in. Example: "jzgmu4ie4delmx7excmgeeb7wz"

        .PARAMETER ItemUUID
        The UUID of the item to update. Example: "q47aqw3sqmqgwcbphjxkjhjtpz"

        .PARAMETER Operation
        The kind of operation to perform. Example: "replace"

        .PARAMETER Path
        An RFC6901 JSON Pointer to the item, an item attribute, an item field by field ID, or an item field attribute. Example: "/fields/vy09gd8EXAMPLE/label"

        .PARAMETER Value
        The new value to apply at the path

        .PARAMETER Token
        The access token to authenticate against the Connector Server API. Example: "$Token | ConvertTo-SecureString -AsPlaintext -Force"

        .PARAMETER ConnectServer
        The uri of the Connector Server API. Example: "http://192.168.1.87:8089"

        .EXAMPLE
        Set-1PasswordItemAttribute -VaultUUID "jzgmu4ie4delmx7excmgeeb7wz" -ItemUUID "q47aqw3sqmqgwcbphjxkjhjtpz" -Operation "replace" -Path "/fields/vy09gd8EXAMPLE/label" -Value "test"

        .EXAMPLE
        Set-1PasswordItemAttribute -VaultUUID "jzgmu4ie4delmx7excmgeeb7wz" -ItemUUID "q47aqw3sqmqgwcbphjxkjhjtpz" -Operation "remove" -Path "/fields/vy09gd8EXAMPLE/label"

        .EXAMPLE
        Set-1PasswordItemAttribute -VaultUUID "jzgmu4ie4delmx7excmgeeb7wz" -ItemUUID "q47aqw3sqmqgwcbphjxkjhjtpz" -Operation "remove" -Path "/fields/vy09gd8EXAMPLE/label" -Token $Token -ConnectServer 'http://192.168.1.87:8089'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $VaultUUID,

        [Parameter(Mandatory = $true)]
        [string] $ItemUUID,

        [Parameter(Mandatory = $true)]
        [ValidateSet('add','remove','replace')]
        [string] $Operation,

        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $false)]
        [string] $Value,

        [Parameter(Mandatory = $false, ParameterSetName = 'Ps1PasswordClient')]
        [securestring] $Token,

        [Parameter(Mandatory = $false, ParameterSetName = 'Ps1PasswordClient')]
        [string] $ConnectServer
    )
    begin {
        $1PasswordClient = Get-1PasswordClient -Token $Token -ConnectServer $ConnectServer

        if (($Operation -eq 'add' -or $Operation -eq 'replace') -and $null -eq $Value) {
            throw "Invalid attribute update, must supply value"
        }

        if ($Operation -eq 'remove' -and $null -ne $Value) {
            throw "Invalid attribute update, don't supply a value for attribute removals"
        }
    }
    process {
        if ($Value) {
            $1PasswordClient.UpdateItemAttribute($VaultUUID, $ItemUUID, $Operation, $Path, $Value)
        } else {
            $1PasswordClient.UpdateItemAttribute($VaultUUID, $ItemUUID, $Operation, $Path)
        }
    }
}
