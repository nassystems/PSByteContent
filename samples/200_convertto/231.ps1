
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
