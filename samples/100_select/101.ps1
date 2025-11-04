
&{
# バイト列からの先頭要素の切り出し
$part101 = Select-ByteContent -First 32 -InputObject $samplebytes
Assert ($part101.GetType() -eq [System.Byte[]])
Assert ($part101.Length -eq 32)
Assert ([convert]::ToBase64String($part101) -eq $sampleb64list[0])

# バイト列からの部分要素の切り出し1
$part102 = Select-ByteContent -First 32 -Skip 32 -InputObject $samplebytes
Assert ($part102.GetType() -eq [System.Byte[]])
Assert ($part102.Length -eq 32)
Assert ([convert]::ToBase64String($part102) -eq $sampleb64list[1])

# バイト列からの部分要素の切り出し2
$part103 = Select-ByteContent -First 32 -Skip ($samplebytes.Length -32) -InputObject $samplebytes
Assert ($part103.GetType() -eq [System.Byte[]])
Assert ($part103.Length -eq 32)
Assert ([convert]::ToBase64String($part103) -eq $sampleb64list[31])

# 入力長が指定長に満たないときは末尾のバイト列を返す
$part104 = Select-ByteContent -First 1024 -Skip ($samplebytes.Length -32) -InputObject $samplebytes
Assert ($part104.GetType() -eq [System.Byte[]])
Assert ($part104.Length -eq 32)
Assert ([convert]::ToBase64String($part104) -eq $sampleb64list[31])

# 入力長が指定に満たないときは何も返さない
$part105 = Select-ByteContent -Skip 4096 -InputObject $samplebytes
Assert ($null -eq $part105)

# スキップ
$part106 = Select-ByteContent -Skip ($samplebytes.Length -32) -InputObject $samplebytes
Assert ($part106.GetType() -eq [System.Byte[]])
Assert ($part106.Length -eq 32)
Assert ([convert]::ToBase64String($part106) -eq $sampleb64list[31])
}
