
# #101 の AsByte テスト

# バイト列からの先頭要素の切り出し
$part101 = Select-ByteContent -First 32 -AsByte -InputObject $samplebytes
Assert ($part101.GetType() -eq [System.Object[]])
Assert ($part101.Length -eq 32)
$skip = 0
for($ix = 0; $ix -lt $part101.Length; ++$ix) {
    Assert ($part101[$ix].GetType() -eq [byte])
    Assert ($part101[$ix] -eq $samplebytes[$skip +$ix])
}

# バイト列からの部分要素の切り出し1
$part102 = Select-ByteContent -First 32 -Skip 32 -AsByte -InputObject $samplebytes
Assert ($part102.GetType() -eq [System.Object[]])
Assert ($part102.Length -eq 32)
$skip = 32
for($ix = 0; $ix -lt $part102.Length; ++$ix) {
    Assert ($part102[$ix].GetType() -eq [byte])
    Assert ($part102[$ix] -eq $samplebytes[$skip +$ix])
}

# バイト列からの部分要素の切り出し2
$part103 = Select-ByteContent -First 32 -Skip ($samplebytes.Length -32) -AsByte -InputObject $samplebytes
Assert ($part103.GetType() -eq [System.Object[]])
Assert ($part103.Length -eq 32)
$skip = $samplebytes.Length -32
for($ix = 0; $ix -lt $part103.Length; ++$ix) {
    Assert ($part103[$ix].GetType() -eq [byte])
    Assert ($part103[$ix] -eq $samplebytes[$skip +$ix])
}

# 入力長が指定に満たないときは末尾のバイト列を返す
$part104 = Select-ByteContent -First 1024 -Skip ($samplebytes.Length -32) -AsByte -InputObject $samplebytes
Assert ($part104.GetType() -eq [System.Object[]])
Assert ($part104.Length -eq 32)
$skip = $samplebytes.Length -32
for($ix = 0; $ix -lt $part104.Length; ++$ix) {
    Assert ($part104[$ix].GetType() -eq [byte])
    Assert ($part104[$ix] -eq $samplebytes[$skip +$ix])
}

# 入力長が指定に満たないときは末尾のバイト列を返す
$part105 = Select-ByteContent -Skip 4096 -AsByte -InputObject $samplebytes
Assert ($null -eq $part105)

# スキップ
$part106 = Select-ByteContent -Skip ($samplebytes.Length -32) -AsByte -InputObject $samplebytes
Assert ($part106.GetType() -eq [System.Object[]])
Assert ($part106.Length -eq 32)
$skip = $samplebytes.Length -32
for($ix = 0; $ix -lt $part106.Length; ++$ix) {
    Assert ($part106[$ix].GetType() -eq [byte])
    Assert ($part106[$ix] -eq $samplebytes[$skip +$ix])
}
