using namespace System.Collections.Generic
[NoRunspaceAffinity()]
class Ps1Password {
    [securestring] $ApiKey
    [boolean] $ApiRequestDebug = $false
    [boolean] $Debug = $false
    [Uri] $ConnectServer

    hidden [string] $LogId

    Ps1Password([securestring] $ApiKey, [uri] $ConnectServer) {
        $this.ApiKey = $ApiKey
        $this.ConnectServer = $ConnectServer
    }

    # get a list of vaults
    [List[Vault]] ListVaults() {
        $VaultList = [List[Vault]]::new()
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, '/v1/vaults').AbsoluteUri
        }

        $Response = $this.SendRequest($Splat)

        foreach ($Vault in $Response) {
            $VaultList.Add([Vault]::new($Vault))
        }

        return $VaultList
    }

    # get a list of vaults with filter
    [List[Vault]] ListVaults([string] $VaultName) {
        $VaultList = [List[Vault]]::new()
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, '/v1/vaults').AbsoluteUri + "?filter=name eq `"$VaultName`""
        }

        $Response = $this.SendRequest($Splat)

        foreach ($Vault in $Response) {
            $VaultList.Add([Vault]::new($Vault))
        }

        return $VaultList
    }

    # get vault details
    [Vault] GetVault([string] $VaultUUID) {
        $Vault = $null
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/vaults/$VaultUUID").AbsoluteUri
        }

        $Response = $this.SendRequest($Splat)

        if ($Response) {
            $Vault = [Vault]::new($Response)
        }

        return $Vault
    }

    # list vault items
    [List[Item]] ListVaultItems([string] $VaultUUID) {
        $ItemList = [List[Item]]::new()
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/vaults/$VaultUUID/items").AbsoluteUri
        }

        $Response = $this.SendRequest($Splat)

        foreach ($Item in $Response) {
            $ItemList.Add([Item]::new($Item))
        }

        return $ItemList
    }

    # list vault items
    [List[Item]] ListVaultItems([string] $VaultUUID, [ItemFilter] $ItemFilter, [string] $Filter) {
        $ItemList = [List[Item]]::new()
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/vaults/$VaultUUID/items").AbsoluteUri + "?filter=$ItemFilter eq `"$Filter`""
        }

        $Response = $this.SendRequest($Splat)

        foreach ($Item in $Response) {
            $ItemList.Add([Item]::new($Item))
        }

        return $ItemList
    }

    # add vault item
    [Item] AddItem([Item] $Item) {
        $ExcludeProperties = @(
            'CreatedAt'
            'UpdatedAt'
            'LastEditedBy'
            'AdditionalInformation'
        )

        $ResponseItem  = $null
        $Splat = @{
            Method = 'Post'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/vaults/$($Item.Vault.Id)/items").AbsoluteUri
            Body   = $Item | Select-Object -ExcludeProperty $ExcludeProperties | ConvertTo-Json -EnumsAsStrings -depth 100
        }

        $Response = $this.SendRequest($Splat)

        if ($Response) {
            $ResponseItem = [Item]::new($Response)
        }

        return $ResponseItem
    }

    # get item details
    [Item] GetItemDetails([string] $VaultUUID, [string] $ItemUUID) {
        $Item = $null
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/vaults/$VaultUUID/items/$ItemUUID").AbsoluteUri
        }

        $Response = $this.SendRequest($Splat)

        if ($Response) {
            $Item = [Item]::new($Response)
        }

        return $Item
    }

    # get item details
    [Item] GetItemDetails([item] $Item) {
        $ItemDetails = $null
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/vaults/$($Item.Vault.Id)/items/$($Item.Id)").AbsoluteUri
        }

        $Response = $this.SendRequest($Splat)

        if ($Response) {
            $ItemDetails = [Item]::new($Response)
        }

        return $ItemDetails
    }

    # replace an item
    [Item] ReplaceItem([item] $Item) {
        $ExcludeProperties = @(
            'CreatedAt'
            'UpdatedAt'
            'LastEditedBy'
            'AdditionalInformation'
        )

        $Splat = @{
            Method = 'Put'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/vaults/$($Item.Vault.Id)/items/$($Item.Id)").AbsoluteUri
            Body   = $Item | Select-Object -ExcludeProperty $ExcludeProperties | ConvertTo-Json -EnumsAsStrings -depth 100
        }

        $Response = $this.SendRequest($Splat)

        if ($Response) {
            $ResponseItem = [Item]::new($Response)
        }

        return $Item
    }

    # delete an item
    [Void] DeleteItem([string] $VaultUUID, [string] $ItemUUID) {
        $Splat = @{
            Method = 'Delete'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/vaults/$VaultUUID/items/$ItemUUID").AbsoluteUri
        }

        $null = $this.SendRequest($Splat)
    }

    # delete an item
    [Void] DeleteItem([Item] $Item) {
        $Splat = @{
            Method = 'Delete'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/vaults/$($Item.Vault.Id)/items/$($Item.Id)").AbsoluteUri
        }

        $null = $this.SendRequest($Splat)
    }

    # update an item attribute
    [Item] UpdateItemAttribute([string] $VaultUUID, [string] $ItemUUID, [string] $Op, [string] $Path, [string] $Value) {
        $Item  = $null
        $Splat = @{
            Method = 'Patch'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/vaults/$VaultUUID/items/$ItemUUID").AbsoluteUri
            Body   = ConvertTo-Json @(@{
                op    = [ValidateSet('add','remove','replace')] $Op
                path  = $Path
                value = $value
            })
        }

        $Response = $this.SendRequest($Splat)

        if ($Response) {
            $Item = [Item]::new($Response)
        }

        return $Item
    }

    # update an item attribute, uses RFC6902 JSON Patch https://datatracker.ietf.org/doc/html/rfc6902
    [Item] UpdateItemAttribute([Item] $Item, [string] $Op, [string] $Path, [string] $Value) {
        $Item  = $null
        $Splat = @{
            Method = 'Patch'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/vaults/$($Item.Vault.Id)/items/$($Item.Id)").AbsoluteUri
            Body   = ConvertTo-Json @(@{
                op    = [ValidateSet('add','replace')] $Op
                path  = $Path
                value = $value
            })
        }

        $Response = $this.SendRequest($Splat)

        if ($Response) {
            $Item = [Item]::new($Response)
        }

        return $Item
    }

    # update an item attribute, uses RFC6902 JSON Patch https://datatracker.ietf.org/doc/html/rfc6902
    [Item] UpdateItemAttribute([Item] $Item, [string] $Op, [string] $Path) {
        $Item  = $null
        $Splat = @{
            Method = 'Patch'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/vaults/$($Item.Vault.Id)/items/$($Item.Id)").AbsoluteUri
            Body   = ConvertTo-Json @(@{
                op    = [ValidateSet('remove')] $Op
                path  = $Path
            })
        }

        $Response = $this.SendRequest($Splat)

        if ($Response) {
            $Item = [Item]::new($Response)
        }

        return $Item
    }

    # list files for an item
    [File[]] ListFiles([string] $VaultUUID, [string] $ItemUUID) {
        $FileList = [List[File]]::new()
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/vaults/$VaultUUID/items/$ItemUUID/files").AbsoluteUri
        }

        $Response = $this.SendRequest($Splat)

        if ($Response) {
            foreach ($File in $Response) {
                $FileList.Add([File]::new($Response))
            }
        }

        return $FileList
    }

    # list files for an item
    [File[]] ListFiles([string] $VaultUUID, [string] $ItemUUID, [bool] $IncludeContent) {
        $FileList = [List[File]]::new()
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/vaults/$VaultUUID/items/$ItemUUID/files?inline_content=$($IncludeContent.ToString().ToLower())").AbsoluteUri
        }

        $Response = $this.SendRequest($Splat)

        if ($Response) {
            foreach ($File in $Response) {
                $FileList.Add([File]::new($Response))
            }
        }

        return $FileList
    }

    # list files for an item
    [File[]] ListFiles([Item] $Item, [bool] $IncludeContent) {
        $FileList = [List[File]]::new()
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/vaults/$($Item.Vault.Id)/items/$($Item.Id)/files?inline_content=$($IncludeContent.ToString().ToLower())").AbsoluteUri
        }

        $Response = $this.SendRequest($Splat)

        if ($Response) {
            foreach ($File in $Response) {
                $FileList.Add([File]::new($Response))
            }
        }

        return $FileList
    }

    # get file details
    [File] GetFileDetails([string] $VaultUUID, [string] $ItemUUID, [string] $FileUUID, [bool] $IncludeContent) {
        $FileDetails = $null
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/vaults/$VaultUUID/items/$ItemUUID/files/$FileUUID`?inline_content=$($IncludeContent.ToString().ToLower())").AbsoluteUri
        }

        $Response = $this.SendRequest($Splat)

        if ($Response) {
            $FileDetails = [File]::new($Response)
        }

        return $FileDetails
    }

    # get file details
    [File] GetFileDetails([File] $File, [bool] $IncludeContent) {
        $FileDetails = $null
        $ContentPath = $File.Content_Path.Replace('/content','')
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, "$ContentPath`?inline_content=$($IncludeContent.ToString().ToLower())").AbsoluteUri
        }

        $Response = $this.SendRequest($Splat)

        if ($Response) {
            $FileDetails = [File]::new($Response)
        }

        return $FileDetails
    }

    # get file content
    [Object] GetFileContent([File] $File) {
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, $File.Content_Path).AbsoluteUri
            Headers = @{
                'Content-Type' = 'application/json'
            }
        }

        $Response = $this.SendRequest($Splat)

        return $Response
    }

    # get file content
    [Object] GetFileContent([string] $VaultUUID, [string] $ItemUUID, [string] $FileUUID) {
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/vaults/$VaultUUID/items/$ItemUUID/files/$FileUUID/content").AbsoluteUri
            Headers = @{
                'Content-Type' = 'application/json'
            }
        }

        $Response = $this.SendRequest($Splat)

        return $Response
    }

    # list api activity
    [List[Request]] ListApiActivity() {
        $RequestList = [List[Request]]::new()
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, "/v1/activity").AbsoluteUri
        }

        $Response = $this.SendRequest($Splat)

        if ($Response) {
            foreach ($Entry in $Response) {
                $RequestList.add([Request]::new($Entry))
            }
        }

        return $RequestList
    }

    # get server heartbeat
    [bool] GetHeartbeat() {
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, "/heartbeat").AbsoluteUri
        }

        $Response = $this.SendRequest($Splat)

        $Status = $Response -eq '.'

        return $Status
    }

    # get server health
    [ServerHealth] GetHealth() {
        $Health = $null
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, "/health").AbsoluteUri
        }

        $Response = $this.SendRequest($Splat)

        if ($Response) {
            $Health = [ServerHealth]::new($Response)
        }


        return $Health
    }

    # get server metrics
    [string] GetMetrics() {
        $Splat = @{
            Method = 'Get'
            Uri    = $this.CombineUri($this.ConnectServer, "/metrics").AbsoluteUri
        }

        $Response = $this.SendRequest($Splat)

        return $Response
    }

    # helper method to send api requests
    [Object] SendRequest([hashtable] $Splat) {
        $Method = "SendRequest([hashtable] splat)"
        $Response = try {
            $Splat = $this.AddHeaders($Splat)

            # log api request details, separate from main debug flag
            if ($this.ApiRequestDebug) {
                $Headers = foreach ($Header in $Splat.Headers.Keys) {
                    if ($Header -eq 'Authorization') {
                        # $ApiKeyValue = $Splat.Headers[$Header]
                        "$Header`: $("*" * 8)"
                    } else {
                        "$Header`: $($Splat.Headers[$Header])"
                    }
                }

                $message = "api request details - Uri: {0}, REST method: {1}, Headers:({2})" -f $Splat.Uri, $Splat.Method, $($Headers -join ', ')
                $this.log($Method,"$message")
            }

            Invoke-WebRequest @Splat
        } catch [System.Net.WebException] {
            if ($this.Debug) {
                $this.log($Method,"$($_.Exception.Message)",'error')
            }

            throw $_.Exception.Response
        } catch [Microsoft.PowerShell.Commands.HttpResponseException] {
            if ($this.Debug) {
                $this.log($Method,"$($_.Exception.Message)",'error')
            }

            throw $_
        } catch {
            if ($this.Debug) {
                $this.log($Method,"$($_.Exception.Message)",'error')
            }

            throw $_
        }

        # log api response details, separate from main debug flag
        if ($this.ApiRequestDebug -and $Response) {
            $ResponseHeaders = foreach ($Header in $Response.Headers.Keys) {
                "$Header`: $($Response.Headers[$Header])"
            }

            $Message = "api response details - StatusCode: {0}, Response Headers:({1})" -f $Response.StatusCode, $($ResponseHeaders -join ', ')
            $this.Log($Method,"$Message")
        }

        $Result = $this.ConvertContent($Response.Content, $Response.Headers['Content-Type'])

        return $Result
    }

    # helper method to send api requests and include response details
    [Object] SendRequest([hashtable] $Splat, [bool] $ResponseDetails) {
        $Method = "SendRequest([hashtable] splat)"
        $Response = try {
            $Splat = $this.AddHeaders($Splat)

            # log api request details, separate from main debug flag
            if ($this.ApiRequestDebug) {
                $Headers = foreach ($Header in $Splat.Headers.Keys) {
                    if ($Header -eq 'Authorization') {
                        # $ApiKeyValue = $Splat.Headers[$Header]
                        "$Header`: $("*" * 8)"
                    } else {
                        "$Header`: $($Splat.Headers[$Header])"
                    }
                }

                $message = "api request details - Uri: {0}, REST method: {1}, Headers:({2})" -f $Splat.Uri, $Splat.Method, $($Headers -join ', ')
                $this.log($Method,"$message")
            }

            Invoke-WebRequest @Splat
        } catch [System.Net.WebException] {
            if ($this.Debug) {
                $this.log($Method,"$($_.Exception.Message)",'error')
            }

            throw $_.Exception.Response
        } catch [Microsoft.PowerShell.Commands.HttpResponseException] {
            if ($this.Debug) {
                $this.log($Method,"$($_.Exception.Message)",'error')
            }

            throw $_
        } catch {
            if ($this.Debug) {
                $this.log($Method,"$($_.Exception.Message)",'error')
            }

            throw $_
        }

        # log api response details, separate from main debug flag
        if ($this.ApiRequestDebug -and $Response) {
            $ResponseHeaders = foreach ($Header in $Response.Headers.Keys) {
                "$Header`: $($Response.Headers[$Header])"
            }

            $Message = "api response details - StatusCode: {0}, Response Headers:({1})" -f $Response.StatusCode, $($ResponseHeaders -join ', ')
            $this.log($Method,"$Message")
        }

        $Result = @{
            Content    = $this.ConvertContent($Response.Content, $Response.Headers['Content-Type'])
            StatusCode = $Response.StatusCode
            Headers    = $Response.Headers
        }

        return $Result
    }

    # log to information stream and file if provided
    hidden [Void] Log([string] $Method, [string] $Message) {
        if (!$this.LogId) {
            $this.SetLogId()
        }

        $Timestamp = Get-Date -format "yyyy-MM-dd HH:mm:ss.fff"
        $StructuredLog = [ordered]@{
            id        = $this.logId
            timestamp = $Timestamp;
            level     = "info";
            hostname  = $env:COMPUTERNAME;
            method    = $Method;
            message   = $Message
        } | ConvertTo-Json -Compress

        $StructuredLog | Write-Information -InformationAction Continue
    }

    # log to information stream and file if provided, specifiy log level
    hidden [Void] Log([string] $method, [string] $message, [string] $level) {
        if (!$this.LogId) {
            $this.SetLogId()
        }

        $Timestamp = Get-Date -format "yyyy-MM-dd HH:mm:ss.fff"
        $StructuredLog = [ordered]@{
            id        = $this.logId
            timestamp = $Timestamp;
            level     = $level;
            hostname  = $env:COMPUTERNAME;
            method    = $Method;
            message   = $Message
        } | ConvertTo-Json -Compress

        $StructuredLog | Write-Information -InformationAction Continue
    }

    # combine uri paths
    hidden [Uri] CombineUri([Uri] $BaseUri, [string] $Path) {
        $Result = $null
        $null   = [Uri]::TryCreate($BaseUri, $Path, [ref] $Result)

        return $Result
    }

    # set log id for request
    hidden [Void] SetLogId() {
        $this.logId = (New-Guid).Guid
    }

    # add required headers
    hidden [hashtable] AddHeaders([hashtable] $RequestSplat) {
        $Accept      = 'application/json'
        $ContentType = 'application/json'

        if ($RequestSplat.ContainsKey('Headers')) {
            $RequestSplat['Headers'].add('Authorization', "Bearer $($this.ConvertFromSecureString($this.ApiKey))")
            $RequestSplat['Headers'].add('Accept', $Accept)
        } else {
            $RequestSplat['Headers'] = @{
                Authorization = "Bearer $($this.ConvertFromSecureString($this.ApiKey))"
                Accept        = $Accept
            }
        }


        if ($RequestSplat['Method'] -in @('POST','PUT','PATCH')) {
            $RequestSplat['Headers'].Add('Content-Type', $ContentType)
        }

        return $RequestSplat
    }

    # convert web request response content
    hidden [Object] ConvertContent([Object] $Content, [string] $ContentType) {
        $Result = Switch ($ContentType) {
            'application/json' {
                $Content | ConvertFrom-Json -Depth 100
            }
            'application/octet-stream' {
                $ParsedContent = [System.Text.Encoding]::UTF8.GetString($Content)

                try {
                    $ParsedContent | ConvertFrom-Json -Depth 100
                } catch {
                    $null = $_
                    $ParsedContent
                }
            }
            default {
                $Content
            }
        }

        return $Result
    }

    hidden [hashtable] ConvertObjectToHashtable([pscustomobject] $PSCustomObject) {
        $Hashtable = @{}
        foreach ($Name in ($PSCustomObject | Get-Member).where({$_.MemberType -eq 'NoteProperty'}).Name) {
            $Hashtable[$Name] = $PSCustomObject.$Name
        }

        return $Hashtable
    }

    hidden [String] ConvertFromSecureString([securestring] $SecureString) {
        return [pscredential]::new('placeholder', $SecureString).GetNetworkCredential().Password
    }
}
