& {
$sampleindex = 7
$arraywrapper.Clear()
$arraywrapper.Add($samplebytelist[$sampleindex])

$bytes = $arraywrapper | ConvertFrom-ByteContent | ConvertTo-ByteContent
Assert ($bytes.GetType() -eq [System.Byte[]])
Assert ($bytes.Length -eq 32)
$b64str = [System.Convert]::ToBase64String($bytes)
Assert ($b64str -eq $sampleb64list[$sampleindex])


$bytes = $arraywrapper | ConvertFrom-ByteContent -SeparatorHash @{4='-'} | ConvertTo-ByteContent
Assert ($bytes.GetType() -eq [System.Byte[]])
Assert ($bytes.Length -eq 32)
$b64str = [System.Convert]::ToBase64String($bytes)
Assert ($b64str -eq $sampleb64list[$sampleindex])


$bytes = $arraywrapper | ConvertFrom-ByteContent -Capital | ConvertTo-ByteContent
Assert ($bytes.GetType() -eq [System.Byte[]])
Assert ($bytes.Length -eq 32)
$b64str = [System.Convert]::ToBase64String($bytes)
Assert ($b64str -eq $sampleb64list[$sampleindex])



$bytes = $arraywrapper | ConvertFrom-ByteContent -Base64 | ConvertTo-ByteContent -Base64
Assert ($bytes.GetType() -eq [System.Byte[]])
Assert ($bytes.Length -eq 32)
$b64str = [System.Convert]::ToBase64String($bytes)
Assert ($b64str -eq $sampleb64list[$sampleindex])

$bytes = $arraywrapper | ConvertFrom-ByteContent -BlockLength 4 -Base64 | ConvertTo-ByteContent -Base64
Assert ($bytes.GetType() -eq [object[]])
Assert ($bytes.Length -eq 11)
$b64str = [System.Convert]::ToBase64String(($bytes | Select-ByteContent -AsByte))
Assert ($b64str -eq $sampleb64list[$sampleindex])

}
