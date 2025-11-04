& {
$stream = New-Object System.IO.MemoryStream

Add-ByteContent -Stream $stream -InputObject $samplebytelist[$sampleindex]
Assert ($stream.Length -eq 32)
Assert ([System.Convert]::ToBase64String($stream.ToArray()) -eq $sampleb64list[$sampleindex])

$stream.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
$bytes = Get-ByteContent -Stream $stream
Assert ($bytes.GetType() -eq [byte[]])
Assert ($bytes.Length -eq 32)
Assert ([System.Convert]::ToBase64String($bytes) -eq $sampleb64list[$sampleindex])

Add-ByteContent -Stream $stream -InputObject $samplebytelist[$sampleindex] -Close
Assert (-not $stream.CanWrite)
Assert ($stream.ToArray().Length -eq 32 *2)
Assert ([System.Convert]::ToBase64String($stream.ToArray(),  0, 32) -eq $sampleb64list[$sampleindex])
Assert ([System.Convert]::ToBase64String($stream.ToArray(), 32, 32) -eq $sampleb64list[$sampleindex])
}
