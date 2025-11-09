& {
$sampleindex = (11..14)
$arraywrapper.Clear()
$sampleindex |% {
    $arraywrapper.Add($samplebytelist[$_])
}

$b64string = $arraywrapper | ConvertFrom-ByteContent -Base64
Assert ($b64string.GetType() -eq [string])
Assert ($b64string -ceq [System.Convert]::ToBase64String(($arraywrapper|%{$_})))

$b64string = $arraywrapper | ConvertFrom-ByteContent -BlockLength 8 -Base64
Assert ($b64string.GetType() -eq [object[]])
Assert ($b64string.Length -eq 22)
$ix = 0
$b64string |% {
    Assert ($b64string[$ix] -ceq [System.Convert]::ToBase64String(($arraywrapper|%{$_})).Substring($ix*8, [math]::min(8, [math]::Ceiling($arraywrapper.Count *32/3)*4 -$ix*8)))
    ++$ix
}

$b64string = $arraywrapper | ConvertFrom-ByteContent -BlockLength 7 -Base64
Assert ($b64string.GetType() -eq [object[]])
Assert ($b64string.Length -eq 25)
$ix = 0
$b64string |% {
    Assert ($b64string[$ix] -ceq [System.Convert]::ToBase64String(($arraywrapper|%{$_})).Substring($ix*7, [math]::min(7, [math]::Ceiling($arraywrapper.Count *32/3)*4 -$ix*7)))
    ++$ix
}

$b64string = $arraywrapper | ConvertFrom-ByteContent -BlockLength 76 -Base64
Assert ($b64string.GetType() -eq [object[]])
Assert ($b64string.Length -eq 3)
$ix = 0
$b64string |% {
    Assert ($b64string[$ix] -ceq [System.Convert]::ToBase64String(($arraywrapper|%{$_})).Substring($ix*76, [math]::min(76, [math]::Ceiling($arraywrapper.Count *32/3)*4 -$ix*76)))
    ++$ix
}
}
