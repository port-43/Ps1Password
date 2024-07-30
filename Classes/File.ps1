class File : IObject {
    [string] $Id
    [bool] $Generate
    [string] $Name
    [Int] $Size
    [string] $Content_Path
    [string] $Content
    [Section] $Section

    File() {}

    File([pscustomobject] $Properties) : Base($Properties) {}

    # output content to file
    [bool] ToFile([System.IO.FileInfo] $Path) {
        $WriteStatus = $false
        if (!$this.Content) {
            return $WriteStatus
        }

        $ByteArray = [System.Convert]::FromBase64String($this.Content)
        [System.IO.File]::WriteAllBytes($Path.FullName, $ByteArray)
        $WriteStatus = $true

        return $WriteStatus
    }
}
