&{
$stream = New-Object System.IO.MemoryStream

$arraywrapper.Clear()
$sampleindexlist |% {
    $arraywrapper.Add($samplebytelist[$_])
}

$arraywrapper | Add-ByteContent -Stream $stream
Assert ($stream.Length -eq 32*$sampleindexlist.Length)
(0..($sampleindexlist.Length -1)) |% {
    Assert ([System.Convert]::ToBase64String($stream.ToArray(), $_*32, 32) -eq $sampleb64list[$sampleindexlist[$_]])
}

$stream.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
$bytes = Get-ByteContent -Stream $stream
Assert ($bytes.GetType() -eq [byte[]])
Assert ($bytes.Length -eq 32*$sampleindexlist.Length)
(0..($sampleindexlist.Length -1)) |% {
    Assert ([System.Convert]::ToBase64String($bytes, $_*32, 32) -eq $sampleb64list[$sampleindexlist[$_]])
}


$stream.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
$bytes = Get-ByteContent -Stream $stream -BufferSize 64
Assert ($bytes.GetType() -eq [object[]])
Assert ($bytes.Length -eq 2)
(0..1) |% {
    Assert ($bytes[$_].GetType() -eq [byte[]])
    Assert ($bytes[$_].Length -eq 32*2)
    Assert ([System.Convert]::ToBase64String($bytes[$_],  0, 32) -eq $sampleb64list[$sampleindexlist[$_*2]])
    Assert ([System.Convert]::ToBase64String($bytes[$_], 32, 32) -eq $sampleb64list[$sampleindexlist[$_*2+1]])
}

$stream.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
$bytes = Get-ByteContent -Stream $stream -First 64 -Skip 32
Assert ($bytes.GetType() -eq [byte[]])
Assert ($bytes.Length -eq 32*2)
(0..1) |% {
    Assert ([System.Convert]::ToBase64String($bytes, $_*32, 32) -eq $sampleb64list[$sampleindexlist[$_ +1]])
}

$bytes = Get-ByteContent -Stream $stream
Assert ($bytes.GetType() -eq [byte[]])
Assert ($bytes.Length -eq 32*($sampleindexlist.Length -3))
(0..($sampleindexlist.Length -4)) |% {
    Assert ([System.Convert]::ToBase64String($bytes, $_*32, 32) -eq $sampleb64list[$sampleindexlist[$_ +3]])
}

$stream.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
$bytes = Get-ByteContent -Stream $stream -BufferSize ($sampleindexlist.Length*32 +128) -Skip 64
Assert ($bytes.GetType() -eq [byte[]])
Assert ($bytes.Length -eq $sampleindexlist.Length*32 -64)
(0..1) |% {
    Assert ([System.Convert]::ToBase64String($bytes, $_*32, 32) -eq $sampleb64list[$sampleindexlist[$_ +2]])
}

$stream.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
$bytes = Get-ByteContent -Stream $stream -BufferSize 32
Assert ($bytes.GetType() -eq [Object[]])
Assert ($bytes.Length -eq $sampleindexlist.Length)
(0..($sampleindexlist.Length -1)) |% {
    Assert ([System.Convert]::ToBase64String($bytes[$_]) -eq $sampleb64list[$sampleindexlist[$_]])
}

$stream.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
$bytes = Get-ByteContent -Stream $stream -BufferSize 32
Assert ($bytes.GetType() -eq [Object[]])
Assert ($bytes.Length -eq $sampleindexlist.Length)
(0..($sampleindexlist.Length -1)) |% {
    Assert ([System.Convert]::ToBase64String($bytes[$_]) -eq $sampleb64list[$sampleindexlist[$_]])
}

$skip = 9
$first = 43
$size = 17
$stream.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
$bytes = Get-ByteContent -Stream $stream -First $first -Skip $skip -BufferSize $size
Assert ($bytes.GetType() -eq [Object[]])
Assert ($bytes.Length -eq [math]::Ceiling($first/$size))
for($ix = 0; $ix -lt $bytes.Length; ++$ix) {
    Assert ($bytes[$ix].GetType() -eq [byte[]])
}
for($ix = 0; $ix -lt $first; ++$ix) {
    Assert (($bytes[[math]::Floor($ix/$size)][$ix%$size]) -eq $samplebytelist[$sampleindexlist[[math]::Floor(($ix +$skip)/32)]][($ix +$skip)%32])
}


$stream.Seek(0, [System.IO.SeekOrigin]::End) | Out-Null
$bytes = Get-ByteContent -Stream $stream -Close
Assert (-not $stream.CanRead)
Assert ($null -eq $bytes)
}
