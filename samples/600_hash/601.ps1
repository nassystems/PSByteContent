& {
$algorithm = New-Object System.Security.Cryptography.SHA1Managed

$hashtext = Hash-ByteContent -InputObject $samplebytelist[$sampleindex]
Assert ($hashtext -eq ($samplehashlist[$sampleindex] | ConvertFrom-ByteContent))

$hashtext = Hash-ByteContent -Algorithms $algorithm -DisposeAlgorithm:$false -InputObject $samplebytelist[$sampleindex]
Assert ($hashtext.GetType() -eq [string])
Assert ($hashtext -eq ($samplehashlist[$sampleindex] | ConvertFrom-ByteContent))

$hashbytes = Hash-ByteContent -Algorithms $algorithm -DisposeAlgorithm -AsString:$false -InputObject $samplebytelist[$sampleindex]
Assert ($hashbytes.GetType() -eq [byte[]])
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
