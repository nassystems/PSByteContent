& {
$sampleix = 0

$tgtfullname = [System.IO.Path]::GetTempFileName()
$tgtfullname
try {
    $s1 = Open-FileStream -LiteralPath $tgtfullname -FileMode Open -FileAccess Write -FileShare Read
    try {
        Assert ($s1.Name -eq $tgtfullname)
        Assert ($s1.CanRead -eq $false)
        Assert ($s1.CanSeek -eq $true)
        Assert ($s1.CanWrite -eq $true)
        
        $s1.Write($samplebytelist[0], 0, $samplebytelist[$sampleix].Length)
        $s1.Flush()
        Assert ($s1.Length -eq $samplebytelist[$sampleix].Length)
        
        $s2 = Open-FileStream -LiteralPath $tgtfullname -FileMode Open -FileAccess Read -FileShare ReadWrite
        try {
            Assert ($s2.Name -eq $tgtfullname)
            Assert ($s2.CanRead -eq $true)
            Assert ($s2.CanSeek -eq $true)
            Assert ($s2.CanWrite -eq $false)
            Assert ($s2.Length -eq $samplebytelist[$sampleix].Length)
            
            $bytes = New-Object byte[] $s2.Length
            $readcount = $s2.Read($bytes, 0, $bytes.Length)
            Assert ($readcount -eq $bytes.Length)
            Assert ([System.Convert]::ToBase64String($bytes) -eq $sampleb64list[$sampleix])
        } finally {
            $s2.Close()
        }
        
        try {
            $s2 = Open-FileStream -LiteralPath $tgtfullname -FileMode Open -FileAccess Write -FileShare ReadWrite
            $s2.Close()
            Assert $true
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
