# バイト列配列を与えたときの動作チェック

# バイト列境界単位1ブロック取得
$first = $byteblock[1].Length
$skip = $byteblock[0].Length
$part = $byteblock | Select-ByteContent -First $first -Skip $skip
Assert ($part.GetType() -eq [System.Byte[]])
Assert ($part.Length -eq $first)
& {
    $ix = $skip
    $part |% {
        $_
    } |% {
        Assert ($_ -eq $samplebytes[$ix])
        $ix = $ix +1
    }
}


# バイト列境界単位複数ブロック取得
$first = 0
(2..4) |% {
    $first = $first +$byteblock[$_].Length
}
$skip = 0
(0..1) |% {
    $skip = $skip +$byteblock[$_].Length
}
$part = $byteblock | Select-ByteContent -First $first -Skip $skip
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 3)
Assert ($part[0].GetType() -eq [System.Byte[]])
Assert ($part[0].Length -eq $byteblock[2].Length)
Assert ($part[1].GetType() -eq [System.Byte[]])
Assert ($part[1].Length -eq $byteblock[3].Length)
Assert ($part[2].GetType() -eq [System.Byte[]])
Assert ($part[2].Length -eq $byteblock[4].Length)
& {
    $ix = $skip
    $part |% {
        $_
    } |% {
        Assert ($_ -eq $samplebytes[$ix])
        $ix = $ix +1
    }
}


# 始点がブロック境界
$first = 13
$skip = 0
(0..3) |% {
    $skip = $skip +$byteblock[$_].Length
}
$part = $byteblock | Select-ByteContent -First $first -Skip $skip
Assert ($part.GetType() -eq [System.Byte[]])
Assert ($part.Length -eq $first)
& {
    $ix = $skip
    $part |% {
        $_
    } |% {
        Assert ($_ -eq $samplebytes[$ix])
        $ix = $ix +1
    }
}

$first = 27
$skip = 0
(0..2) |% {
    $skip = $skip +$byteblock[$_].Length
}
$part = $byteblock | Select-ByteContent -First $first -Skip $skip
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 3)
Assert ($part[0].GetType() -eq [System.Byte[]])
Assert ($part[0].Length -eq $byteblock[3].Length)
Assert ($part[1].GetType() -eq [System.Byte[]])
Assert ($part[1].Length -eq $byteblock[4].Length)
Assert ($part[2].GetType() -eq [System.Byte[]])
Assert ($part[2].Length -eq 2)
& {
    $ix = $skip
    $part |% {
        $_
    } |% {
        Assert -InputObject ($_ -eq $samplebytes[$ix])
        $ix = $ix +1
    }
}


# 終端がブロック境界
$first = 5
$skip = 40
$part = $byteblock | Select-ByteContent -First $first -Skip $skip
Assert ($part.GetType() -eq [System.Byte[]])
Assert ($part.Length -eq $first)
& {
    $ix = $skip
    $part |% {
        $_
    } |% {
        Assert ($_ -eq $samplebytes[$ix])
        $ix = $ix +1
    }
}

$first = 32
$skip = 40
$part = $byteblock | Select-ByteContent -First $first -Skip $skip
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 3)
Assert ($part[0].GetType() -eq [System.Byte[]])
Assert ($part[0].Length -eq 5)
Assert ($part[1].GetType() -eq [System.Byte[]])
Assert ($part[1].Length -eq $byteblock[4].Length)
Assert ($part[2].GetType() -eq [System.Byte[]])
Assert ($part[2].Length -eq 10)
& {
    $ix = $skip
    $part |% {
        $_
    } |% {
        Assert ($_ -eq $samplebytes[$ix])
        $ix = $ix +1
    }
}


# ブロックに跨る範囲 (短)
$first = 8
$skip = 78
$part = $byteblock | Select-ByteContent -First $first -Skip $skip
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 2)
Assert ($part[0].GetType() -eq [System.Byte[]])
Assert ($part[0].Length -eq 4)
Assert ($part[1].GetType() -eq [System.Byte[]])
Assert ($part[1].Length -eq 4)
& {
    $ix = $skip
    $part |% {
        $_
    } |% {
        Assert ($_ -eq $samplebytes[$ix])
        $ix = $ix +1
    }
}

# ブロックに跨る範囲 (長)
$first = 33
$skip = 70
$part = $byteblock | Select-ByteContent -First $first -Skip $skip
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 5)
Assert ($part[0].GetType() -eq [System.Byte[]])
Assert ($part[0].Length -eq 3)
Assert ($part[1].GetType() -eq [System.Byte[]])
Assert ($part[1].Length -eq $byteblock[6].Length)
Assert ($part[2].GetType() -eq [System.Byte[]])
Assert ($part[2].Length -eq $byteblock[7].Length)
Assert ($part[3].GetType() -eq [System.Byte[]])
Assert ($part[3].Length -eq $byteblock[8].Length)
Assert ($part[4].GetType() -eq [System.Byte[]])
Assert ($part[4].Length -eq 9)
& {
    $ix = $skip
    $part |% {
        $_
    } |% {
        Assert ($_ -eq $samplebytes[$ix]) -Message ('index {0} was unmatched.' -f $ix)
        $ix = $ix +1
    }
}
