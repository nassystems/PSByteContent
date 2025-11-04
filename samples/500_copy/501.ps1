& {
$sampleindex = 19
$sampleindexlist = (6..9)

$source = New-Object System.IO.MemoryStream
$destination = New-Object System.IO.MemoryStream

$arraywrapper.Clear()
$sampleindexlist |% {
    $arraywrapper.Add($samplebytelist[$_])
}
$arraywrapper | Add-ByteContent -Stream $source

$source.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
$destination.SetLength(0)
Copy-Stream -SourceStream $source -DestinationStream $destination

Assert ($destination.Length -eq $source.Length)
$destination.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
(0..($sampleindexlist.Length -1)) |% {
    $bytes = Get-ByteContent -Stream $destination -First 32
    Assert ($bytes.GetType() -eq [byte[]])
    Assert ($bytes.Length -eq 32)
    Assert ([System.Convert]::ToBase64String($bytes) -eq $sampleb64list[$sampleindexlist[$_]])
}



$source.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
$destination.SetLength(0)
Copy-Stream -SourceStream $source -DestinationStream $destination -BufferSize 32

Assert ($destination.Length -eq $source.Length)
$destination.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
(0..($sampleindexlist.Length -1)) |% {
    $bytes = Get-ByteContent -Stream $destination -First 32
    Assert ($bytes.GetType() -eq [byte[]])
    Assert ($bytes.Length -eq 32)
    Assert ([System.Convert]::ToBase64String($bytes) -eq $sampleb64list[$sampleindexlist[$_]])
}



$source.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
$destination.SetLength(0)
Copy-Stream -SourceStream $source -DestinationStream $destination -BufferSize 13

Assert ($destination.Length -eq $source.Length)
$destination.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
(0..($sampleindexlist.Length -1)) |% {
    $bytes = Get-ByteContent -Stream $destination -First 32
    Assert ($bytes.GetType() -eq [byte[]])
    Assert ($bytes.Length -eq 32)
    Assert ([System.Convert]::ToBase64String($bytes) -eq $sampleb64list[$sampleindexlist[$_]])
}



$source.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
$destination.SetLength(0)
Copy-Stream -SourceStream $source -DestinationStream $destination -BufferSize ($source.Length -1)

Assert ($destination.Length -eq $source.Length)
$destination.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
(0..($sampleindexlist.Length -1)) |% {
    $bytes = Get-ByteContent -Stream $destination -First 32
    Assert ($bytes.GetType() -eq [byte[]])
    Assert ($bytes.Length -eq 32)
    Assert ([System.Convert]::ToBase64String($bytes) -eq $sampleb64list[$sampleindexlist[$_]])
}

$destination.Close()
$source.Close()

}
