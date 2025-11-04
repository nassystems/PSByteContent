&{
$stream = New-Object System.IO.MemoryStream

$arraywrapper.Clear()
$sampleindexlist |% {
    $arraywrapper.Add($samplebytelist[$_])
}

$bytes = $arraywrapper | Add-ByteContent -Stream $stream -PassThru
Assert ($stream.Length -eq 32*$sampleindexlist.Length)
Assert ($bytes.Length -eq $sampleindexlist.Length)

(0..($sampleindexlist.Length -1)) |% {
    Assert ([System.Convert]::ToBase64String($stream.ToArray(), $_*32, 32) -eq $sampleb64list[$sampleindexlist[$_]])
    Assert ([System.Convert]::ToBase64String($bytes[$_]) -eq $sampleb64list[$sampleindexlist[$_]])
}
}
