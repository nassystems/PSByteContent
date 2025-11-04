& {
$algorithm = New-Object System.Security.Cryptography.SHA1Managed

$stream = New-Object System.IO.MemoryStream
Add-ByteContent -Stream $stream -InputObject $samplebytelist[$sampleindex]

$stream.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
$hashtext = Hash-Stream -Stream $stream
Assert ($hashtext -eq ($samplehashlist[$sampleindex] | ConvertFrom-ByteContent))

$stream.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
$hashtext = Hash-Stream -Stream $stream -Algorithms $algorithm -DisposeAlgorithm:$false
Assert ($hashtext -eq ($samplehashlist[$sampleindex] | ConvertFrom-ByteContent))

$stream.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
$hashbytes = Hash-Stream -Stream $stream -Algorithms $algorithm -DisposeAlgorithm -AsString:$false
Assert ([System.Convert]::ToBase64String($hashbytes) -eq [System.Convert]::ToBase64String($samplehashlist[$sampleindex]))

try {
    if($algorithm -is [System.IDisposable]) {
        $algorithm.TransformFinalBlock(@(), 0, 0)
        Assert $false
    }
} catch {
    Assert ($null -ne $_.Exception)
    Assert ($null -ne $_.Exception.InnerException)
    Assert ($_.Exception.InnerException.GetType() -eq [System.ObjectDisposedException])
}
}
