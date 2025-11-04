
# #111 の AsByte テスト

$part = Select-ByteContent -Last 32 -AsByte -InputObject $samplebytes
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 32)
$skip = $samplebytes.Length -32
for($ix = 0; $ix -lt $part.Length; ++$ix) {
    Assert ($part[$ix].GetType() -eq [byte])
    Assert ($part[$ix] -eq $samplebytes[$skip +$ix])
}

$part = Select-ByteContent -Last 4096 -AsByte -InputObject $samplebytes
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq $samplebytes.Length)
$skip = 0
for($ix = 0; $ix -lt $part.Length; ++$ix) {
    Assert ($part[$ix].GetType() -eq [byte])
    Assert ($part[$ix] -eq $samplebytes[$skip +$ix])
}
