class IObject {
    IObject() {}

    IObject([pscustomobject] $Properties) {
        foreach ($Property in $this.psobject.properties.Name) {
            if ($Properties.$Property) {
                $this.$Property = $Properties.$Property
            }
        }
    }

    [Void] Init([hashtable] $Properties) {
        foreach ($Key in $Properties.Keys) {
            try {
                $this.$Key = $Properties[$Key]
            } catch {
                $null = $_
            }
        }
    }
}
