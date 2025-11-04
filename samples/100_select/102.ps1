# バイト列配列を与えたときの動作チェック

&{
# バイトブロック境界単位 1 ブロック取得
$part = $samplebytelist | Select-ByteContent -First 32 -Skip 32
Assert ($part.GetType() -eq [System.Byte[]])
Assert ($part.Length -eq 32)
Assert ([convert]::ToBase64String($part) -eq $sampleb64list[1])
}
&{
# バイトブロック境界単位 複数ブロック取得
$part = $samplebytelist | Select-ByteContent -First 96 -Skip 64
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 3)
Assert ($part[0].GetType() -eq [System.Byte[]])
Assert ($part[0].Length -eq 32)
Assert ($part[1].GetType() -eq [System.Byte[]])
Assert ($part[1].Length -eq 32)
Assert ($part[2].GetType() -eq [System.Byte[]])
Assert ($part[2].Length -eq 32)
Assert ([convert]::ToBase64String($part[0]) -eq $sampleb64list[2])
Assert ([convert]::ToBase64String($part[1]) -eq $sampleb64list[3])
Assert ([convert]::ToBase64String($part[2]) -eq $sampleb64list[4])
}

&{
# 始点がブロック境界
$part = $samplebytelist | Select-ByteContent -First 21 -Skip 32
Assert ($part.GetType() -eq [System.Byte[]])
Assert ($part.Length -eq 21)
for($ix = 0; $ix -lt $part.Length; ++$ix) {
    Assert ($part[$ix].GetType() -eq [byte])
    Assert ($part[$ix] -eq $samplebytelist[1][$ix])
}
}
&{
$part = $samplebytelist | Select-ByteContent -First 100 -Skip 64
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 4)
Assert ($part[0].GetType() -eq [System.Byte[]])
Assert ($part[0].Length -eq 32)
Assert ($part[1].GetType() -eq [System.Byte[]])
Assert ($part[1].Length -eq 32)
Assert ($part[2].GetType() -eq [System.Byte[]])
Assert ($part[2].Length -eq 32)
Assert ($part[3].GetType() -eq [System.Byte[]])
Assert ($part[3].Length -eq 4)
Assert ([convert]::ToBase64String($part[0]) -eq $sampleb64list[2])
Assert ([convert]::ToBase64String($part[1]) -eq $sampleb64list[3])
Assert ([convert]::ToBase64String($part[2]) -eq $sampleb64list[4])
for($ix = 0; $ix -lt $part[3].Length; ++$ix) {
    Assert ($part[3][$ix].GetType() -eq [byte])
    Assert ($part[3][$ix] -eq $samplebytelist[5][$ix])
}
}

&{
# 終端がブロック境界
$part = $samplebytelist | Select-ByteContent -First 20 -Skip 108
Assert ($part.GetType() -eq [System.Byte[]])
Assert ($part.Length -eq 20)
$skip = 12
for($ix = 0; $ix -lt $part.Length; ++$ix) {
    Assert ($part[$ix].GetType() -eq [byte])
    Assert ($part[$ix] -eq $samplebytelist[3][$skip +$ix])
}
}
&{
$part = $samplebytelist | Select-ByteContent -First (12+64) -Skip 20
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 3)
Assert ($part[0].GetType() -eq [System.Byte[]])
Assert ($part[0].Length -eq 12)
Assert ($part[1].GetType() -eq [System.Byte[]])
Assert ($part[1].Length -eq 32)
Assert ($part[2].GetType() -eq [System.Byte[]])
Assert ($part[2].Length -eq 32)
$skip = 20
for($ix = 0; $ix -lt $part[0].Length; ++$ix) {
    Assert ($part[0][$ix].GetType() -eq [byte])
    Assert ($part[0][$ix] -eq $samplebytes[$skip +$ix])
}
Assert ([convert]::ToBase64String($part[1]) -eq $sampleb64list[1])
Assert ([convert]::ToBase64String($part[2]) -eq $sampleb64list[2])
}

&{
# ブロックに跨る範囲 (短)
$part = $samplebytelist | Select-ByteContent -First 30 -Skip 27
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 2)
Assert ($part[0].GetType() -eq [System.Byte[]])
Assert ($part[0].Length -eq 5)
$skip = 27
for($ix = 0; $ix -lt $part[0].Length; ++$ix) {
    Assert ($part[0][$ix].GetType() -eq [byte])
    Assert ($part[0][$ix] -eq $samplebytelist[0][$skip +$ix])
}
Assert ($part[1].GetType() -eq [System.Byte[]])
Assert ($part[1].Length -eq 25)
$skip = 0
for($ix = 0; $ix -lt $part[1].Length; ++$ix) {
    Assert ($part[1][$ix].GetType() -eq [byte])
    Assert ($part[1][$ix] -eq $samplebytelist[1][$skip +$ix])
}
}
&{
# ブロックに跨る範囲 (長)
$part = $samplebytelist | Select-ByteContent -First 121 -Skip 79
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 5)
Assert ($part[0].GetType() -eq [System.Byte[]])
Assert ($part[0].Length -eq 17)
Assert ($part[1].GetType() -eq [System.Byte[]])
Assert ($part[1].Length -eq 32)
Assert ($part[2].GetType() -eq [System.Byte[]])
Assert ($part[2].Length -eq 32)
Assert ($part[3].GetType() -eq [System.Byte[]])
Assert ($part[3].Length -eq 32)
Assert ($part[4].GetType() -eq [System.Byte[]])
Assert ($part[4].Length -eq 8)
$skip = 79-64
for($ix = 0; $ix -lt $part[0].Length; ++$ix) {
    Assert ($part[0][$ix].GetType() -eq [byte])
    Assert ($part[0][$ix] -eq $samplebytelist[2][$skip +$ix])
}
Assert ([convert]::ToBase64String($part[1]) -eq $sampleb64list[3])
Assert ([convert]::ToBase64String($part[2]) -eq $sampleb64list[4])
Assert ([convert]::ToBase64String($part[3]) -eq $sampleb64list[5])
$skip = 0
for($ix = 0; $ix -lt $part[4].Length; ++$ix) {
    Assert ($part[4][$ix].GetType() -eq [byte])
    Assert ($part[4][$ix] -eq $samplebytelist[6][$skip +$ix])
}
}
