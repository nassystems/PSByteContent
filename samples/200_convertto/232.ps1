& {                
$sampleindex = (11..14)
$arraywrapper.Clear()
$sampleindex |% {
    $arraywrapper.Add($samplebytelist[$_])
}


$bytes = $arraywrapper |% {$_ | ConvertFrom-ByteContent} | ConvertTo-ByteContent
Assert ($bytes.GetType() -eq [object[]])
Assert ($bytes.Length -eq 4)
(0..($sampleindex.Length -1)) |% {
    Assert ($bytes[$_].GetType() -eq [System.Byte[]])
    Assert ($bytes[$_].Length -eq 32)
    $b64str = [System.Convert]::ToBase64String($bytes[$_])
    Assert ($b64str -eq $sampleb64list[$sampleindex[$_]])
}

$bytes = $arraywrapper |% {$_ | ConvertFrom-ByteContent -Base64} | ConvertTo-ByteContent -Base64
Assert ($bytes.GetType() -eq [object[]])
Assert ($bytes.Length -eq 4)
(0..($sampleindex.Length -1)) |% {
    Assert ($bytes[$_].GetType() -eq [System.Byte[]])
    Assert ($bytes[$_].Length -eq 32)
    $b64str = [System.Convert]::ToBase64String($bytes[$_])
    Assert ($b64str -eq $sampleb64list[$sampleindex[$_]])
}

}
