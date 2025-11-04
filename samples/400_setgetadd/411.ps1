& {
$stream = New-Object System.IO.MemoryStream

$bytes = Add-ByteContent -Stream $stream -InputObject $samplebytelist[$sampleindex] -PassThru
Assert ($stream.Length -eq 32)
Assert ([System.Convert]::ToBase64String($stream.ToArray()) -eq $sampleb64list[$sampleindex])
Assert ($bytes.GetType() -eq [byte[]])
Assert ($bytes.Length -eq 32)
Assert ([System.Convert]::ToBase64String($bytes) -eq $sampleb64list[$sampleindex])
}
