& {
$algorithms = New-Object System.Security.Cryptography.HashAlgorithm[] 3
$algorithms[0] = New-Object System.Security.Cryptography.MD5CryptoServiceProvider
$algorithms[1] = New-Object System.Security.Cryptography.SHA1Managed
$algorithms[2] = New-Object System.Security.Cryptography.SHA256Managed

$tgtfile = 'C:\Windows\System32\notepad.exe'
$stream = Open-FileStream -LiteralPath $tgtfile
$hashtext = $stream | Hash-Stream -Algorithms $algorithms -DisposeAlgorithm:$false
Assert ($hashtext[0] -eq (certutil.exe -hashfile $tgtfile md5    |? {$_ -match '^([0-9a-fA-F]{2}\s?)+$'}).Replace(' ', ''))
Assert ($hashtext[1] -eq (certutil.exe -hashfile $tgtfile sha1   |? {$_ -match '^([0-9a-fA-F]{2}\s?)+$'}).Replace(' ', ''))
Assert ($hashtext[2] -eq (certutil.exe -hashfile $tgtfile sha256 |? {$_ -match '^([0-9a-fA-F]{2}\s?)+$'}).Replace(' ', ''))
Assert ($stream.CanRead)

$stream.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
$hashtext = $stream | Hash-Stream -Algorithms $algorithms -Close -DisposeAlgorithm:$false -BufferSize 65536
Assert ($hashtext[0] -eq (certutil.exe -hashfile $tgtfile md5    |? {$_ -match '^([0-9a-fA-F]{2}\s?)+$'}).Replace(' ', ''))
Assert ($hashtext[1] -eq (certutil.exe -hashfile $tgtfile sha1   |? {$_ -match '^([0-9a-fA-F]{2}\s?)+$'}).Replace(' ', ''))
Assert ($hashtext[2] -eq (certutil.exe -hashfile $tgtfile sha256 |? {$_ -match '^([0-9a-fA-F]{2}\s?)+$'}).Replace(' ', ''))
Assert (-not $stream.CanRead)

$tgtfile = 'C:\Windows\System32\calc.exe'
$stream = Open-FileStream -LiteralPath $tgtfile
$hashtext = $stream | Hash-Stream -Algorithms $algorithms -Close -DisposeAlgorithm
Assert ($hashtext[0] -eq (certutil.exe -hashfile $tgtfile md5    |? {$_ -match '^([0-9a-fA-F]{2}\s?)+$'}).Replace(' ', ''))
Assert ($hashtext[1] -eq (certutil.exe -hashfile $tgtfile sha1   |? {$_ -match '^([0-9a-fA-F]{2}\s?)+$'}).Replace(' ', ''))
Assert ($hashtext[2] -eq (certutil.exe -hashfile $tgtfile sha256 |? {$_ -match '^([0-9a-fA-F]{2}\s?)+$'}).Replace(' ', ''))
Assert (-not $stream.CanRead)

$algorithms |% {
    try {
        if($_ -is [System.IDisposable]) {
            $_.TransformFinalBlock(@(), 0, 0)
            Assert $false
        }
    } catch {
        Assert ($null -ne $_.Exception)
        Assert ($null -ne $_.Exception.InnerException)
        Assert ($_.Exception.InnerException.GetType() -eq [System.ObjectDisposedException])
    }
}
}
