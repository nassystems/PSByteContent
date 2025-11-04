& {
$tgtfullname = [System.IO.Path]::GetTempFileName()
$tgtfullname
try {
    $s1 = Open-FileStream -LiteralPath $tgtfullname -FileMode Open -FileAccess Read -FileShare Read
    try {
        Assert ($s1.Name -eq $tgtfullname)
        Assert ($s1.CanRead -eq $true)
        Assert ($s1.CanSeek -eq $true)
        Assert ($s1.CanWrite -eq $false)
        
        $s2 = Open-FileStream -LiteralPath $tgtfullname -FileMode Open -FileAccess Read -FileShare Read
        try {
            Assert ($s2.Name -eq $tgtfullname)
            Assert ($s2.CanRead -eq $true)
            Assert ($s2.CanSeek -eq $true)
            Assert ($s2.CanWrite -eq $false)
        } finally {
            $s2.Close()
        }
        
        try {
            $s2 = Open-FileStream -LiteralPath $tgtfullname -FileMode Open -FileAccess Write -FileShare ReadWrite
            $s2.Close()
            Assert $false
        } catch {
            Assert ($null -ne $_.Exception)
            Assert ($null -ne $_.Exception.InnerException)
            Assert ($_.Exception.InnerException.GetType() -eq [System.IO.IOException])
        }
        
        Close-Stream -InputObject $s1
        Assert ($s1.CanRead -eq $false)
        Assert ($s1.CanSeek -eq $false)
        Assert ($s1.CanWrite -eq $false)
    } finally {
        $s1.Dispose()
    }
} finally {
    Remove-Item -LiteralPath $tgtfullname
}
}
