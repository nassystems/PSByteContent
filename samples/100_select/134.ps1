& {
# 配列平滑化により 1 バイトずつに分割される
# 1 バイトずつの要素がバイト配列になる
$part = $samplebytelist[0] | Select-ByteContent
Assert ($part.GetType() -eq [System.Byte[]])
Assert ($part.Length -eq 32)
Assert ([convert]::ToBase64String($part) -eq $sampleb64list[0])
}
& {
$part = (0..3) |% {$samplebytelist[$_]} | Select-ByteContent
Assert ($part.GetType() -eq [System.Byte[]])
Assert ($part.Length -eq 128)
Assert ([convert]::ToBase64String($part,  0, 32) -eq $sampleb64list[0])
Assert ([convert]::ToBase64String($part, 32, 32) -eq $sampleb64list[1])
Assert ([convert]::ToBase64String($part, 64, 32) -eq $sampleb64list[2])
Assert ([convert]::ToBase64String($part, 96, 32) -eq $sampleb64list[3])
}
& {
$part = $samplebytes | Select-ByteContent -First 32 -Skip 64
Assert ($part.GetType() -eq [System.Byte[]])
Assert ($part.Length -eq 32)
Assert ([convert]::ToBase64String($part) -eq $sampleb64list[2])
}

& {
# 連続した 1 バイトがバイト配列へ変換される。
$arraywrapper.Clear()
$samplebytelist[0] |% {
    $b = New-Object byte[] 1
    $b[0] = $_
    $arraywrapper.Add($b)
}
$arraywrapper.Add($samplebytelist[1])
$samplebytelist[2] |% {
    $b = New-Object byte[] 1
    $b[0] = $_
    $arraywrapper.Add($b)
}
$arraywrapper.Add($samplebytelist[3])

$part = $arraywrapper | Select-ByteContent
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 4)
Assert ($part[0].GetType() -eq [System.Byte[]])
Assert ($part[0].Length -eq 32)
Assert ([convert]::ToBase64String($part[0]) -eq $sampleb64list[0])
Assert ($part[1].GetType() -eq [System.Byte[]])
Assert ($part[1].Length -eq 32)
Assert ([convert]::ToBase64String($part[1]) -eq $sampleb64list[1])
Assert ($part[2].GetType() -eq [System.Byte[]])
Assert ($part[2].Length -eq 32)
Assert ([convert]::ToBase64String($part[2]) -eq $sampleb64list[2])
Assert ($part[3].GetType() -eq [System.Byte[]])
Assert ($part[3].Length -eq 32)
Assert ([convert]::ToBase64String($part[3]) -eq $sampleb64list[3])
}
