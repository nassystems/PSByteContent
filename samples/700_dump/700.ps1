
# 70x テスト前提試料

$sampleindex = 23
$sampleindexlist = (6..9)

$arraywrapper.Clear()
$sampleindexlist |% {
    $arraywrapper.Add($samplebytelist[$_])
}

$tgttext = New-Object System.Text.StringBuilder
