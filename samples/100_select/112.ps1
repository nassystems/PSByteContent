&{
$part = $samplebytelist | Select-ByteContent -Last 32
Assert ($part.GetType() -eq [System.Byte[]])
Assert ($part.Length -eq 32)
Assert ([convert]::ToBase64String($part) -eq $sampleb64list[$sampleb64list.Count -1])
}
&{
$part = $samplebytelist | Select-ByteContent -Last 4096
Assert ($part.GetType() -eq [System.Object[]])
Assert ($part.Length -eq 32)
$ix = 0
while($ix -lt $samplebytelist.Count) {
    Assert ($part[$ix].GetType() -eq [System.Byte[]])
    Assert ($part[$ix].Length -eq 32)
    Assert ([convert]::ToBase64String($part[$ix]) -eq $sampleb64list[$ix])
    ++$ix
}
}
&{
@(10, 31, 32, 33, 95, 96, 97, 100, 1000, 1023, 1024) |% {
    $lastcount = $_
    $part = $samplebytelist | Select-ByteContent -Last $lastcount
    $bytearraycount = [int] [math]::Ceiling($lastcount /32)
    if($bytearraycount -gt 1) {
        Assert ($part.GetType() -eq [System.Object[]]) -Message ('failed when $lastcount is {0}' -f $lastcount)
        Assert ($part.Length -eq $bytearraycount) -Message ('failed when $lastcount is {0}' -f $lastcount)
        
        $ix = 1
        while($ix -lt $bytearraycount) {
            $currentpart = $part[$bytearraycount -$ix]
            
            Assert ($currentpart.GetType() -eq [System.Byte[]]) -Message ('failed when $lastcount is {0} and $ix is {1}' -f $lastcount, $ix)
            Assert ($currentpart.Length -eq 32) -Message ('failed when $lastcount is {0} and $ix is {1}' -f $lastcount, $ix)
            Assert ([convert]::ToBase64String($currentpart) -eq $sampleb64list[32 -$ix]) -Message ('failed when $lastcount is {0} and $ix is {1}' -f $lastcount, $ix)
            
            $ix = $ix +1
        }
        Assert ($part[0].GetType() -eq [System.Byte[]]) -Message ('failed when $lastcount is {0}' -f $lastcount)
        Assert ($part[0].Length -eq ($lastcount -1) %32 +1) -Message ('failed when $lastcount is {0}' -f $lastcount)
        $currentpart = $part[0]
    } else {
        Assert ($part.GetType() -eq [System.Byte[]]) -Message ('failed when $lastcount is {0}' -f $lastcount)
        Assert ($part.Length -eq $lastcount) -Message ('failed when $lastcount is {0}' -f $lastcount)
        $currentpart = $part
    }
    $ix = 1024-$lastcount
    $currentpart |% {
        Assert ($_ -eq $samplebytes[$ix]) -Message ('failed when $lastcount is {0} and $ix is {1}' -f $lastcount, $ix)
        $ix = $ix +1
    }
}
}
