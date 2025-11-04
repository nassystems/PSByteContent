$tgtfullname = [System.IO.Path]::GetTempFileName()
$tgtfullname
try {
    $path = [System.IO.Path]::GetDirectoryName($tgtfullname)
    $name = [System.IO.Path]::GetFileName($tgtfullname)
    
    Push-Location $path
    try {
        $s1 = Open-FileStream -LiteralPath $name
        try {
            Assert ($s1.Name -eq $tgtfullname)
            Assert ($s1.CanRead -eq $true)
            Assert ($s1.CanSeek -eq $true)
            Assert ($s1.CanWrite -eq $false)
            
            Close-Stream -InputObject $s1
            Assert ($s1.CanRead -eq $false)
            Assert ($s1.CanSeek -eq $false)
            Assert ($s1.CanWrite -eq $false)
        } finally {
            $s1.Dispose()
        }
    } finally {
        Pop-Location
    }
} finally {
    Remove-Item -LiteralPath $tgtfullname
}
