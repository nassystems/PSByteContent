# Last テスト
&{
$part = Select-ByteContent -Last 32 -InputObject $samplebytes
Assert ($part.GetType() -eq [System.Byte[]])
Assert ($part.Length -eq 32)
Assert ([convert]::ToBase64String($part) -eq $sampleb64list[$sampleb64list.Count -1])
}
&{
$part = Select-ByteContent -Last 4096 -InputObject $samplebytes
Assert ($part.GetType() -eq [System.Byte[]])
Assert ($part.Length -eq 1024)
for($ix = 0; $ix -lt $part.Length; ++$ix) {
    Assert ($part[$ix].GetType() -eq [byte])
    Assert ($part[$ix] -eq $samplebytes[$ix])
}
}
& {
$part = Select-ByteContent -Last 32 -Skip 32 -InputObject $samplebytes
Assert ($part.GetType() -eq [System.Byte[]])
Assert ($part.Length -eq 32)
Assert ([convert]::ToBase64String($part) -eq $sampleb64list[$sampleb64list.Count -2])
}
