& {
$sampleix = 23

$b64string = ConvertFrom-ByteContent -Base64 -InputObject $samplebytelist[$sampleix]
Assert ($b64string.GetType() -eq [string])
Assert ($b64string -ceq $sampleb64list[$sampleix])

$b64string = ConvertFrom-ByteContent -BlockLength 8 -Base64 -InputObject $samplebytelist[$sampleix]
Assert ($b64string.GetType() -eq [object[]])
Assert ($b64string.Length -eq 6)
$ix = 0
$b64string |% {
    Assert ($b64string[$ix] -ceq $sampleb64list[$sampleix].Substring($ix*8, [math]::min(8, $sampleb64list[$sampleix].Length -$ix*8)))
    ++$ix
}

$b64string = ConvertFrom-ByteContent -BlockLength 7 -Base64 -InputObject $samplebytelist[$sampleix]
Assert ($b64string.GetType() -eq [object[]])
Assert ($b64string.Length -eq 7)
$ix = 0
$b64string |% {
    Assert ($b64string[$ix] -ceq $sampleb64list[$sampleix].Substring($ix*7, [math]::min(7, $sampleb64list[$sampleix].Length -$ix*7)))
    ++$ix
}
}
