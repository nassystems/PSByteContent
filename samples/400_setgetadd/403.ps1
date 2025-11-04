# seek 不能ストリームのテスト
&{


$arraywrapper.Clear()
$sampleindexlist |% {
    $arraywrapper.Add($samplebytelist[$_])
}

&{
    $pipe = New-Object System.IO.Pipes.AnonymousPipeServerStream
    $writer = $pipe
    $reader = New-Object System.IO.Pipes.AnonymousPipeClientStream ([System.IO.Pipes.PipeDirection]::In), $pipe.ClientSafePipeHandle
    
    $arraywrapper | Add-ByteContent -Stream $writer -Close
    
    $bytes = Get-ByteContent -Stream $reader -Close
    Assert ($bytes.GetType() -eq [byte[]])
    Assert ($bytes.Length -eq 32*$sampleindexlist.Length)
    (0..($sampleindexlist.Length -1)) |% {
        Assert ([System.Convert]::ToBase64String($bytes, $_*32, 32) -eq $sampleb64list[$sampleindexlist[$_]])
    }
}


& {
    $pipe = New-Object System.IO.Pipes.AnonymousPipeServerStream
    $writer = $pipe
    $reader = New-Object System.IO.Pipes.AnonymousPipeClientStream ([System.IO.Pipes.PipeDirection]::In), $pipe.ClientSafePipeHandle
    
    $arraywrapper | Add-ByteContent -Stream $writer -Close
    
    $bytes = Get-ByteContent -Stream $reader -Skip 32 -Close
    Assert ($bytes.GetType() -eq [byte[]])
    Assert ($bytes.Length -eq 32*($sampleindexlist.Length -1))
    (0..($sampleindexlist.Length -2)) |% {
        Assert ([System.Convert]::ToBase64String($bytes, $_*32, 32) -eq $sampleb64list[$sampleindexlist[$_ +1]])
    }
}

& {
    $pipe = New-Object System.IO.Pipes.AnonymousPipeServerStream
    $writer = $pipe
    $reader = New-Object System.IO.Pipes.AnonymousPipeClientStream ([System.IO.Pipes.PipeDirection]::In), $pipe.ClientSafePipeHandle
    
    $arraywrapper | Add-ByteContent -Stream $writer -Close
    
    $bytes = Get-ByteContent -Stream $reader -First 64 -Skip 32 -Close
    Assert ($bytes.GetType() -eq [byte[]])
    Assert ($bytes.Length -eq 32*2)
    (0..1) |% {
        Assert ([System.Convert]::ToBase64String($bytes, $_*32, 32) -eq $sampleb64list[$sampleindexlist[$_ +1]])
    }
}

&{
    $pipe = New-Object System.IO.Pipes.AnonymousPipeServerStream
    $writer = $pipe
    $reader = New-Object System.IO.Pipes.AnonymousPipeClientStream ([System.IO.Pipes.PipeDirection]::In), $pipe.ClientSafePipeHandle
    
    $arraywrapper | Add-ByteContent -Stream $writer -Close
    
    $bytes = Get-ByteContent -Stream $reader -BufferSize 32 -Close
    Assert ($bytes.GetType() -eq [Object[]])
    Assert ($bytes.Length -eq $sampleindexlist.Length)
    (0..($sampleindexlist.Length -1)) |% {
        Assert ([System.Convert]::ToBase64String($bytes[$_]) -eq $sampleb64list[$sampleindexlist[$_]])
    }
}

& {
    $skip = 79
    $first = 40
    $size = 7
    
    $pipe = New-Object System.IO.Pipes.AnonymousPipeServerStream
    $writer = $pipe
    $reader = New-Object System.IO.Pipes.AnonymousPipeClientStream ([System.IO.Pipes.PipeDirection]::In), $pipe.ClientSafePipeHandle
    
    $arraywrapper | Add-ByteContent -Stream $writer -Close
    
    $bytes = Get-ByteContent -Stream $reader -First $first -Skip $skip -BufferSize $size
    Assert ($bytes.GetType() -eq [Object[]])
    Assert ($bytes.Length -eq [math]::Ceiling($first/$size))
    for($ix = 0; $ix -lt $bytes.Length; ++$ix) {
        Assert ($bytes[$ix].GetType() -eq [byte[]])
    }
    for($ix = 0; $ix -lt $first; ++$ix) {
        Assert (($bytes[[math]::Floor($ix/$size)][$ix%$size]) -eq $samplebytelist[$sampleindexlist[[math]::Floor(($ix +$skip)/32)]][($ix +$skip)%32])
    }
}
}
