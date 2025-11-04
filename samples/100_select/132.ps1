# #102 の AsByte テスト

# バイトブロック境界単位 1 ブロック取得
$part = $samplebytelist | Select-ByteContent -First 32 -Skip 32 -AsByte
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 32)
$skip = 32
for($ix = 0; $ix -lt $part.Length; ++$ix) {
    Assert ($part[$ix].GetType() -eq [byte])
    Assert ($part[$ix] -eq $samplebytes[$skip +$ix])
}

# バイトブロック境界単位 複数ブロック取得
$part = $samplebytelist | Select-ByteContent -First 96 -Skip 64 -AsByte
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 96)
$skip = 64
for($ix = 0; $ix -lt $part.Length; ++$ix) {
    Assert ($part[$ix].GetType() -eq [byte])
    Assert ($part[$ix] -eq $samplebytes[$skip +$ix])
}

# 始点がブロック境界
$part = $samplebytelist | Select-ByteContent -First 21 -Skip 32 -AsByte
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 21)
$skip = 32
for($ix = 0; $ix -lt $part.Length; ++$ix) {
    Assert ($part[$ix].GetType() -eq [byte])
    Assert ($part[$ix] -eq $samplebytes[$skip +$ix])
}

$part = $samplebytelist | Select-ByteContent -First 100 -Skip 64 -AsByte
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 100)
$skip = 64
for($ix = 0; $ix -lt $part.Length; ++$ix) {
    Assert ($part[$ix].GetType() -eq [byte])
    Assert ($part[$ix] -eq $samplebytes[$skip +$ix])
}


# 終端がブロック境界
$part = $samplebytelist | Select-ByteContent -First 20 -Skip 108 -AsByte
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 20)
$skip = 108
for($ix = 0; $ix -lt $part.Length; ++$ix) {
    Assert ($part[$ix].GetType() -eq [byte])
    Assert ($part[$ix] -eq $samplebytes[$skip +$ix])
}

$part = $samplebytelist | Select-ByteContent -First (12+64) -Skip 20 -AsByte
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 76)
$skip = 20
for($ix = 0; $ix -lt $part.Length; ++$ix) {
    Assert ($part[$ix].GetType() -eq [byte])
    Assert ($part[$ix] -eq $samplebytes[$skip +$ix])
}


# ブロックに跨る範囲 (短)
$part = $samplebytelist | Select-ByteContent -First 30 -Skip 27 -AsByte
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 30)
$skip = 27
for($ix = 0; $ix -lt $part.Length; ++$ix) {
    Assert ($part[$ix].GetType() -eq [byte])
    Assert ($part[$ix] -eq $samplebytes[$skip +$ix])
}

# ブロックに跨る範囲 (長)
$part = $samplebytelist | Select-ByteContent -First 121 -Skip 79 -AsByte
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 121)
$skip = 79
for($ix = 0; $ix -lt $part.Length; ++$ix) {
    Assert ($part[$ix].GetType() -eq [byte])
    Assert ($part[$ix] -eq $samplebytes[$skip +$ix])
}
