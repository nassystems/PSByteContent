
# さまざまな配列長のバイト列に対するテスト (のための資材作成/12xの前提)

$byteblock = & {
    $blocksizelist = @(19, 9, 9, 8, 17, 11, 1, 8, 12, 14, 5, 19)
    $result = New-Object byte[][] $blocksizelist.Length
    $startbyte = 0
    $ix = 0
    while($ix -lt $blocksizelist.Length) {
        $blocksize = $blocksizelist[$ix]
        $result[$ix] = Select-ByteContent -First $blocksize -Skip $startbyte -InputObject $samplebytes
    
        $ix = $ix +1
        $startbyte = $startbyte +$blocksize
    }
    $result
}
