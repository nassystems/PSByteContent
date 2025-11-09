<#
.SYNOPSIS
PSByteContentLib
PowerShell でバイナリを扱うための関数群。
.NOTES
PSByteContentLib version 1.03

MIT License

Copyright (c) 2025 Isao Sato

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>

function Select-ByteContent {
    <#
    .Synopsis
    バイト列から選択したバイト列を出力する。
    .Parameter First
    入力バイト列の先頭から選択するバイト数を指定する。
    .Parameter Skip
    入力バイト列の先頭からスキップするバイト数を指定する。
    .Parameter Last
    入力バイト列の末尾から選択するバイト数を指定する。
    .Parameter AsByte
    出力をバイト列ではなく 1 バイトずつ出力する。
    .Parameter InputObject
    選択するバイト列を指定する。
    #>
    [CmdletBinding(DefaultParameterSetName='First')]
    param(
        [Parameter(Position=0, ParameterSetName='First')]
        [int64] $First = [int64]::MaxValue,
        [Parameter(Position=0, ParameterSetName='Last')]
        [int64] $Last,
        [Parameter(Position=1, ParameterSetName='Last')]
        [Parameter(Position=1, ParameterSetName='First')]
        [int64] $Skip = [int64] 0,
        [Parameter(Position=2, ParameterSetName='First')]
        [Parameter(Position=2, ParameterSetName='Last')]
        [switch] $AsByte,
        [Parameter(Position=3, Mandatory=$true, ValueFromPipeline=$true, ParameterSetName='First')]
        [Parameter(Position=3, Mandatory=$true, ValueFromPipeline=$true, ParameterSetName='Last')]
        [Byte[]] $InputObject)
    begin {
        $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
        Set-StrictMode -Version 3
        
        $totalreadlength = [int64] 0
        $totalwritelength = [int64] 0
        $resultwrapper = $null
        $onebytelist   = $null
        New-Variable -Name onebytelistmaxlength -Value (1024*1024) -Option Constant
        $lastlogic = $false
        $lastbuffer      = $null
        $lastbuffercount = $null
        
        switch($PSCmdlet.ParameterSetName) {
            'Last' {
                $lastlogic = $true
                $lastbuffer      = New-Object System.Collections.Generic.List[Byte[]]
                $lastbuffercount = New-Object System.Collections.Generic.List[int]
            }
            default {
                $resultwrapper = New-Object System.Collections.Generic.List[byte[]]
                if(-not $AsByte.IsPresent){
                    $onebytelist = New-Object System.Collections.Generic.List[byte]
                }
                
                function WriteBytes {
                    param([byte[]] $Bytes)
                
                    if($AsByte) {
                        $Bytes
                    } else {
                        if($Bytes.Length -eq 1) {
                            $onebytelist.Add($Bytes[0])
                            if($onebytelist.Count -ge $onebytelistmaxlength) {
                                $resultwrapper.Clear()
                                $resultwrapper.Add($onebytelist.ToArray())
                                $onebytelist.Clear()
                                $resultwrapper
                            }
                        } else {
                            $resultwrapper.Clear()
                            if($onebytelist.Count -gt 0) {
                                $resultwrapper.Add($onebytelist.ToArray())
                                $onebytelist.Clear()
                            }
                            $resultwrapper.Add($Bytes)
                            $resultwrapper
                        }
                    }
                }
            }
        }
    }
    process {
        if($lastlogic) {
            $lastbuffer.Add($InputObject)
            
            $ix = 0
            while($ix -lt $lastbuffercount.Count) {
                $lastbuffercount[$ix] = $lastbuffercount[$ix] +$InputObject.Length
                $ix = $ix +1
            }
            $lastbuffercount.Add(0)
            
            while($lastbuffercount[0] -gt ($Last +$Skip)) {
                $lastbuffer.RemoveAt(0)
                $lastbuffercount.RemoveAt(0)
            }
        } else {
            if($totalreadlength -lt $Skip) {
                $lengthtmp = $totalreadlength +$InputObject.Length -$Skip
                if($lengthtmp -gt 0) {
                    $start = $InputObject.GetLowerBound(0) +[int] ($Skip -$totalreadlength)
                    $length = [int] [math]::Min($First, $lengthtmp)
                    if(($InputObject.GetLowerBound(0) -eq $start) -and ($InputObject.GetUpperBound(0) +1 -$start -$length -eq 0)) {
                        WriteBytes -Bytes $InputObject
                    } else {
                        $resultbytes = New-Object Byte[] $length
                        [array]::Copy($InputObject, $start, $resultbytes, 0, $length)
                        WriteBytes -Bytes $resultbytes
                    }
                    $totalwritelength += $length
                }
            } else {
                $requiredlength = $First -$totalwritelength
                if($requiredlength -gt 0) {
                    $start = $InputObject.GetLowerBound(0)
                    if($InputObject.Length -le $requiredlength) {
                        WriteBytes -Bytes $InputObject
                        $totalwritelength += $InputObject.Length
                    } else {
                        $resultbytes = New-Object Byte[] $requiredlength
                        [array]::Copy($InputObject, $start, $resultbytes, 0, $requiredlength)
                        WriteBytes -Bytes $resultbytes
                        $totalwritelength += $requiredlength
                    }
                }
            }
            $totalreadlength += $InputObject.Length
        }
    }
    end {
        if($lastlogic) {
            $totalbufferedlength = $lastbuffercount[0] +$lastbuffer[0].Length
            if($totalbufferedlength -gt ($Last +$Skip)) {
                $skipcount = $totalbufferedlength -$Last -$Skip
            } else {
                $skipcount = 0
            }
            $lastbuffer | Select-ByteContent -First $Last -Skip $skipcount -AsByte:$AsByte
        } else {
            if($null -ne $onebytelist) {
                if($onebytelist.Count -gt 0) {
                    $resultwrapper.Clear()
                    $resultwrapper.Add($onebytelist.ToArray())
                    $resultwrapper
                }
            }
        }
    }
}

function ConvertFrom-ByteContent {
    <#
    .Synopsis 
    バイト列を文字列へ変換する。
    .Parameter BlockLength
    区切り文字または改行を挿入するバイト数 (Hex 文字列の場合) または文字数
    (Base64 の場合) を指定する。SeparatorHash と排他。
    .Parameter Separator
    Hex 文字列へ変換する場合、BlockLength で指定したバイト数ごとに挿入する区
    切り文字列を指定する。対応する文字列を指定しなかった区切り位置では文字列
    が分割される。SeparatorHash と排他。
    .Parameter SeparatorHash
    HEX 文字列へ変換する場合、区切り文字列をハッシュリストで指定する。キーに
    区切り長を、値に区切り文字]列を指定する。文字列を指定せず $null を指定し
    た位置では文字列が分割される。BlockLength および Separator と排他。
    .Parameter Capital
    16 進数を大文字で出力する。既定は小文字。
    .Parameter Base64
    Base64 文字列を出力する。既定は HEX 文字列。
    .Parameter InputObject
    変換するバイト列を指定する。
    #>
    [CmdletBinding(DefaultParametersetName='SeparatorHashHex')]
    param(
        [Parameter(Position=0, ParameterSetName='SeparatorsHex')]
        [Parameter(Position=0, ParameterSetName='SeparatorsB64')]
        [Alias('BlockLengths')]
        [int[]]   $BlockLength,
        [Parameter(Position=1, ParameterSetName='SeparatorsHex')]
        [Alias('Separators')]
        [string[]] $Separator,
        [Parameter(Position=0, ParameterSetName='SeparatorHashHex')]
        [hashtable] $SeparatorHash,
        [Parameter(Position=2, ParameterSetName='SeparatorsHex')]
        [Parameter(Position=1, ParameterSetName='SeparatorHashHex')]
        [switch] $Capital,
        [Parameter(Position=1, ParameterSetName='SeparatorsB64')]
        [switch] $Base64,
        [Parameter(Position=3, ParameterSetName='SeparatorsHex',    ValueFromPipeline=$true)]
        [Parameter(Position=2, ParameterSetName='SeparatorHashHex', ValueFromPipeline=$true)]
        [Parameter(Position=2, ParameterSetName='SeparatorsB64',    ValueFromPipeline=$true)]
        [Byte[]] $InputObject)
    begin {
        $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
        Set-StrictMode -Version 3
        
        if($null -eq $SeparatorHash) {
            $SeparatorHash = @{}
        }
        
        if($PSCmdlet.ParameterSetName -eq 'SeparatorsHex' -or $PSCmdlet.ParameterSetName -eq 'SeparatorsB64') {
            if($null -ne $BlockLength) {
                for($ix = 0; $ix -lt $BlockLength.Length; ++$ix) {
                    if($null -ne $Separator -and $Separator.Length -gt $ix) {
                        $SeparatorHash.Add($BlockLength[$ix], $Separator[$ix])
                    } else {
                        $SeparatorHash.Add($BlockLength[$ix], $null)
                    }
                }
            }
        }
        
        $blocklengthlist = New-Object System.Collections.Generic.List[int]
        $blockcountlist  = New-Object System.Collections.Generic.Dictionary[int`,int]
        $byteseparator = [string]::Empty
        
        $SeparatorHash.Keys | Sort-Object |% {
            if($_ -ne 1) {
                $blocklengthlist.Add($_)
                $blockcountlist[$_] = 0
            } else {
                $byteseparator = $SeparatorHash[1]
            }
        }
        
        if($Base64.IsPresent) {
            $threebytescount = 0
            $threebytesbuffer = New-Object Byte[] 3
        } else {
            $separatorstring = [string]::Empty
        }
        
        $Result = New-Object System.Text.StringBuilder
    }
    process {
        if($Base64.IsPresent) {
            if($threebytescount -ne 0 -and $InputObject.Length +$threebytescount -ge 3) {
                $inputcount = 3 -$threebytescount
                [Byte[]]::Copy($InputObject, 0, $threebytesbuffer, $threebytescount, $inputcount)
                $threebytescount = $threebytescount +$inputcount
                [void] $Result.Append([System.Convert]::ToBase64String($threebytesbuffer))
                $threebytescount = 0
            } else {
                $inputcount = 0
            }
            $threebytesbufferblocks = [math]::Floor(($InputObject.Length -$inputcount)/3)
            [void] $Result.Append([System.Convert]::ToBase64String($InputObject, $inputcount, $threebytesbufferblocks*3))
            $inputcount = $inputcount +$threebytesbufferblocks*3
            
            [Byte[]]::Copy($InputObject, $inputcount, $threebytesbuffer, $threebytescount, $InputObject.Length -$inputcount)
            $threebytescount = $threebytescount +$InputObject.Length -$inputcount
            
            do {
                $targetlength = [int]::MaxValue
                foreach($blocklen in $blocklengthlist) {
                    $blockcount = $blockcountlist[$blocklen]
                    if($targetlength -ge ($blocklen -$blockcount)) {
                        $separatorstring = $SeparatorHash[$blocklen]
                        $targetlength    = $blocklen -$blockcount
                    }
                }
                $blocklengthlist |% {
                    $blockcountlist[$_] = ($blockcountlist[$_] +$targetlength) % $_
                }
                if($Result.Length -ge $targetlength) {
                    $Result.ToString(0, $targetlength)
                    [void] $Result.Remove(0, $targetlength)
                } else {
                    break
                }
            } while($true)
        } else {
            $inputcount = 0
            
            while($inputcount -lt $InputObject.Length) {
                if($null -eq $separatorstring) {
                    $Result.ToString()
                    [void] $Result.Clear()
                } else {
                    [void] $Result.Append($separatorstring)
                }
                
                $nextblocklength = 0
                $targetlength = [int]::MaxValue
                $separatorstring = [string]::Empty
                foreach($blocklen in $blocklengthlist) {
                    $blockcount = $blockcountlist[$blocklen]
                    if($targetlength -ge ($blocklen -$blockcount)) {
                        $nextblocklength = $blocklen
                        $separatorstring = $SeparatorHash[$blocklen]
                        $targetlength    = $blocklen -$blockcount
                    }
                }
                if(($InputObject.Length -$inputcount) -lt $targetlength) {
                    $targetlength = $InputObject.Length -$inputcount
                    $separatorstring = $byteseparator
                }
                $blocklengthlist |% {
                    $blockcountlist[$_] = ($blockcountlist[$_] +$targetlength) % $_
                }
                
                $targetbyte = Select-ByteContent -First $targetlength -Skip $inputcount -InputObject $InputObject
                $bytetext = [System.BitConverter]::ToString($targetbyte)
                if(-not $Capital) {
                    $bytetext = $bytetext.ToLower()
                }
                $bytetext = $bytetext.Replace('-', $byteseparator)
                [void] $Result.Append($bytetext)
                $inputcount = $inputcount +$targetlength
            }
        }
    }
    end {
        if($Base64.IsPresent) {
            if($threebytescount -ne 0) {
                [void] $Result.Append([System.Convert]::ToBase64String($threebytesbuffer, 0, $threebytescount))
                do {
                    $targetlength = [int]::MaxValue
                    foreach($blocklen in $blocklengthlist) {
                        $blockcount = $blockcountlist[$blocklen]
                        if($targetlength -ge ($blocklen -$blockcount)) {
                            $separatorstring = $SeparatorHash[$blocklen]
                            $targetlength    = $blocklen -$blockcount
                        }
                    }
                    $blocklengthlist |% {
                        $blockcountlist[$_] = ($blockcountlist[$_] +$targetlength) % $_
                    }
                    if($Result.Length -ge $targetlength) {
                        $Result.ToString(0, $targetlength)
                        [void] $Result.Remove(0, $targetlength)
                    } else {
                        break
                    }
                } while($true)
            }
        }
        if($Result.Length -gt 0) {
            $Result.ToString()
        }
    }
}

function ConvertTo-ByteContent {
    <#
    .Synopsis 
    文字列をバイト列へ変換する。
    .Description
    HEX 文字列の場合、文字列から 16 進数 2 桁ずつを抽出し Byte 値へ変換する。それ以外の文字や 1 桁の 16 進数は無視される。
    .Parameter Base64
    Base64 文字列を変換する。既定は Hex 文字列。
    .Parameter InputObject
    変換する文字列を指定する。
    #>
    [CmdletBinding(DefaultParametersetName='Hex')]
    param(
        [Parameter(Position=0, ParameterSetName='Base64')]
        [switch] $Base64,
        [Parameter(Position=0, ParameterSetName='Hex',    Mandatory=$true, ValueFromPipeline=$true)]
        [Parameter(Position=1, ParameterSetName='Base64', Mandatory=$true, ValueFromPipeline=$true)]
        [string] $InputObject)
    begin {
        if($Base64.IsPresent) {
            $fourcharsbuffer = New-Object System.Text.StringBuilder 4
        } else {
            $hexstringpattern = New-Object System.Text.RegularExpressions.Regex '[0-9a-fA-F]{2}'
        }
        $bytecontent = New-Object System.Collections.Generic.List[byte]
        $resultwrapper = New-Object System.Collections.Generic.List[byte[]]
    }
    process {
        if($Base64.IsPresent) {
            if($fourcharsbuffer.Length -ne 0 -and $InputObject.Length +$fourcharsbuffer.Length -ge 4) {
                $inputcount = 4- $fourcharsbuffer.Length
                [void] $fourcharsbuffer.Append($InputObject, 0, $inputcount)
                $bytecontent.AddRange([System.Convert]::FromBase64String($fourcharsbuffer.ToString()))
                [void] $fourcharsbuffer.Clear()
            } else {
                $inputcount = 0
            }
            $fourcharsbufferblocks = [math]::Floor(($InputObject.Length -$inputcount)/4)
            if($fourcharsbufferblocks -gt 0) {
                $bytecontent.AddRange([System.Convert]::FromBase64String($InputObject.Substring($inputcount, $fourcharsbufferblocks*4)))
                $inputcount = $inputcount +$fourcharsbufferblocks*4
            }
            if($InputObject.Length -gt $inputcount) {
                [void] $fourcharsbuffer.Append($InputObject, $inputcount, $InputObject.Length -$inputcount)
            }
        } else {
            $hexstringpattern.Matches($InputObject) |% {
                $bytecontent.Add([byte]::Parse($_.Value, [System.Globalization.NumberStyles]::AllowHexSpecifier))
            }
        }
        if($bytecontent.Count -gt 0) {
            $resultwrapper.Clear()
            $resultwrapper.Add($bytecontent.ToArray())
            $resultwrapper
            $bytecontent.Clear()
        }
    }
}

function Open-FileStream {
    <#
    .Synopsis
    ファイルを開き、ファイルオブジェクトを返す。返されたファイルオブジェクト
    は Close-Stream 関数またはオブジェクトのメソッドで閉じる必要がある。
    .Parameter LiteralPath
    ファイルパスを指定する。
    .Parameter FileMode
    ファイルのオープンまたは作成の決定方法を指定する。
    .Parameter FileAccess
    ファイルのアクセス方法を指定する。
    .Parameter FileShare
    ファイルの共有方法を指定する。
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string] $LiteralPath,
        [System.IO.FileMode]   $FileMode   = ([System.IO.FileMode]::Open),
        [System.IO.FileAccess] $FileAccess = ([System.IO.FileAccess]::Read),
        [System.IO.FileShare]  $FileShare  = ([System.IO.FileShare]::Read))
    
    $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
    Set-StrictMode -Version 3
    
    $currentpath = [System.Environment]::CurrentDirectory
    try {
        if('FileSystem' -eq $pwd.Provider.Name) {
            [System.Environment]::CurrentDirectory = $pwd.ProviderPath
        }
        $fstream = New-Object System.IO.FileStream $LiteralPath, $FileMode, $FileAccess, $FileShare
    } finally {
        [System.Environment]::CurrentDirectory = $currentpath
    }
    $fstream
}

function Close-Stream {
    <#
    .Synopsis
    Open-FileStream で開いたファイルを閉じる。
    .Parameter InputObject
    Open-FileStream で開いたファイルオブジェクトを指定する。
    #>
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
        [System.IO.Stream] $InputObject)
    
    $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
    Set-StrictMode -Version 3
    
    $InputObject.Close()
}

function Add-ByteContent {
    <#
    .Synopsis
    バイト列をストリームまたはファイルへ追記出力する。
    .Parameter LiteralPath
    出力ファイルパスを指定する。
    .Parameter Stream
    出力ストリームを [System.IO.Stream] 派生クラス インスタンスで指定する。
    .Parameter PassThru
    処理中のバイト列を標準出力へ出力する。規定では何も出力しない。
    .Parameter Close
    処理後に出力ストリームを閉じる。
    .Parameter InputObject
    出力するバイト列を指定する。
    #>
    [CmdletBinding(DefaultParametersetName='Stream')]
    param(
        [Parameter(ParameterSetName='LiteralPath', Position=0)]
        [string] $LiteralPath,
        [Parameter(ParameterSetName='Stream',      Position=0)]
        [System.IO.Stream] $Stream,
        [Parameter(ParameterSetName='LiteralPath', Position=1)]
        [Parameter(ParameterSetName='Stream',      Position=1)]
        [switch] $PassThru,
        [Parameter(ParameterSetName='Stream',      Position=2)]
        [switch] $Close,
        [Parameter(ParameterSetName='LiteralPath', Position=2, Mandatory=$true, ValueFromPipeline=$true)]
        [Parameter(ParameterSetName='Stream',      Position=3, Mandatory=$true, ValueFromPipeline=$true)]
        [Byte[]] $InputObject)
    begin {
        $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
        Set-StrictMode -Version 3
        
        $disposerequiredlist = New-Object System.Collections.Generic.List[System.IDisposable]
        try {
            switch($PSCmdlet.ParameterSetName) {
                'Stream' {
                    $tgtstream = $Stream
                    if($Close.IsPresent) {
                        $disposerequiredlist.Add($tgtstream)
                    }
                }
                default {
                    $tgtstream = Open-FileStream -LiteralPath $LiteralPath -FileMode Append -FileAccess Write -FileShare Read
                    $disposerequiredlist.Add($tgtstream)
                }
            }
            
            $resultwrapper = New-Object System.Collections.Generic.List[byte[]]
        } catch {
            $disposerequiredlist |% {$_.Dispose()}
            throw
        }
    }
    process {
        try {
            $start = $InputObject.GetLowerBound(0)
            $length = $InputObject.Length
            $tgtstream.Write($InputObject, $start, $length)
            if($PassThru.IsPresent) {
                $resultwrapper.Clear()
                $resultwrapper.Add($InputObject)
                $resultwrapper
            }
        } catch {
            $disposerequiredlist |% {$_.Dispose()}
            throw
        }
    }
    end {
        $disposerequiredlist |% {$_.Dispose()}
    }
}

function Get-ByteContent {
    <#
    .Synopsis
    ストリームまたはファイルから入力したバイト列を返す。
    .Parameter LiteralPath
    入力ファイルパスを指定する。
    .Parameter Stream
    入力ストリームを [System.IO.Stream] 派生クラス インスタンスで指定する。
    .Parameter First
    入力バイト列の先頭から選択するバイト数を指定する。
    .Parameter Skip
    入力バイト列の先頭からスキップするバイト数を指定する。
    .Parameter Force
    入力ファイルパスを指定した場合に、ファイルが書き込みオープン中でも可能な
    場合は開く。但し、処理中にファイル内容が書き換わると部分的に古い一貫性の
    ないバイト列を取得し、データが破損するリスクがある。
    .Parameter Close
    処理後に入力ストリームを閉じる。
    .Parameter BufferSize
    内部バッファサイズ。既定は 1 MB。
    .Parameter SuppressProgress
    プログレスバーを非表示にする。なお、入力ストリームがシーク不可能な場合は
    本オプション指定に関わらずプログレスバーを表示しない。
    .Parameter ShowDotProgress
    処理経過をホストへのドット記号出力で示す。BufferSize でサイズ指定するバッ
    ファを処理するごとに 1 ドットを出力する。入力ストリームがシーク不能な場合
    でも経過が出力される。
    #>
    [CmdletBinding(DefaultParametersetName='Stream')]
    param(
        [Parameter(ParameterSetName='LiteralPath', Position=0)]
        [string] $LiteralPath,
        [Parameter(ParameterSetName='Stream', Position=0, ValueFromPipeline=$true)]
        [System.IO.Stream] $Stream,
        [Parameter(ParameterSetName='LiteralPath', Position=1)]
        [Parameter(ParameterSetName='Stream',      Position=1)]
        [Int64] $First = ([Int64]::MaxValue),
        [Parameter(ParameterSetName='LiteralPath', Position=2)]
        [Parameter(ParameterSetName='Stream',      Position=2)]
        [Int64] $Skip,
        [Parameter(ParameterSetName='LiteralPath', Position=3)]
        [switch] $Force,
        [Parameter(ParameterSetName='Stream',      Position=3)]
        [switch] $Close,
        [Parameter(ParameterSetName='LiteralPath', Position=4)]
        [Parameter(ParameterSetName='Stream',      Position=4)]
        [int] $BufferSize = (1024*1024),
        [Parameter(ParameterSetName='LiteralPath', Position=5)]
        [Parameter(ParameterSetName='Stream',      Position=5)]
        [switch] $SuppressProgress,
        [Parameter(ParameterSetName='LiteralPath', Position=6)]
        [Parameter(ParameterSetName='Stream',      Position=6)]
        [switch] $ShowDotProgress)
    
    $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
    Set-StrictMode -Version 3
    
    New-Variable -Name MaxBufferSize -Value $BufferSize -Option Constant
    $buffer = New-Object Byte[] $MaxBufferSize
    [int64] $totalread = 0
    [int64] $skipread = 0
    
    $tgtstream = $null
    $resultwrapper = New-Object System.Collections.Generic.List[byte[]]
    $disposerequiredlist = New-Object 'System.Collections.Generic.List[System.IDisposable]'
    try {
        switch($PsCmdlet.ParameterSetName) {
            'Stream' {
                $tgtstream = $Stream
                if($Close.IsPresent) {
                    $disposerequiredlist.Add($tgtstream)
                }
            }
            default {
                try {
                    $tgtstream = Open-FileStream -LiteralPath $LiteralPath -FileMode Open -FileAccess Read -FileShare Read
                } catch {
                    if($Force.IsPresent -and $null -ne $_.Exception -and $null -ne $_.Exception.InnerException -and $_.Exception.InnerException.GetType() -eq [System.IO.IOException]) {
                        $tgtstream = Open-FileStream -LiteralPath $LiteralPath -FileMode Open -FileAccess Read -FileShare ReadWrite
                    } else {
                        throw
                    }
                }
                $disposerequiredlist.Add($tgtstream)
            }
        }
        
        # for progress
        $refreshprogress = [datetime]::MaxValue
        [long] $totallength = 0
        if(-not $SuppressProgress.IsPresent -and $tgtstream.CanSeek) {
            $totallength = [math]::Min($First, $tgtstream.Length -$tgtstream.Position)
            $refreshprogress = [datetime]::Now +[timespan]::FromSeconds(1)
        }
        
        function doprogress {
            if([datetime]::Now -gt $refreshprogress) {
                $percent = [Math]::Min(($totalread +$skipread) / $totallength * 100, 100)
                Write-Progress -Activity 'Get-ByteContent' -Status ('getting... {0:0.0}%' -f $percent) -PercentComplete $percent
                $refreshprogress = [datetime]::Now +[timespan]::FromMilliseconds(100)
            }
            if($ShowDotProgress.IsPresent) {
                Write-Host '.' -NoNewline
            }
        }
        
        :zeroread do {
            if($tgtstream.CanSeek) {
                $requiredposition = [math]::Min($Skip +$tgtstream.Position, $tgtstream.Length)
                while($tgtstream.Position -ne $requiredposition) {
                    $tgtstream.Seek($requiredposition, [System.IO.SeekOrigin]::Begin) | Out-Null
                }
                if($tgtstream.Length -le $requiredposition) {break zeroread}
            } else {
                $totallength += $Skip
                while(($skipread +$MaxBufferSize) -le $Skip) {
                    $readlength = $tgtstream.Read($buffer, 0, $MaxBufferSize)
                    $skipread += $readlength
                    if($readlength -eq 0) {break zeroread}
                    doprogress
                }
                while($skipread -lt $Skip) {
                    $requiredlength = $Skip -$skipread
                    $readlength = $tgtstream.Read($buffer, 0, $requiredlength)
                    $skipread += $readlength
                    if($readlength -eq 0) {break zeroread}
                    doprogress
                }
            }
            
            $buffer = New-Object Byte[] $MaxBufferSize
            while(($totalread +$MaxBufferSize) -le $First) {
                $readlength = $tgtstream.Read($buffer, 0, $MaxBufferSize)
                $totalread += $readlength
                if($readlength -eq 0) {break zeroread}
                if($readlength -lt $MaxBufferSize) {
                    $outbuffer = New-Object Byte[] $readlength
                    [byte[]]::Copy($buffer, $outbuffer, $readlength)
                } else {
                    $outbuffer = $buffer
                    $buffer = New-Object Byte[] $MaxBufferSize
                }
                $resultwrapper.Clear()
                $resultwrapper.Add($outbuffer)
                $resultwrapper
                doprogress
            }
            while($totalread -lt $First) {
                $requiredlength = $First -$totalread
                $readlength = $tgtstream.Read($buffer, 0, $requiredlength)
                $totalread += $readlength
                if($readlength -eq 0) {break zeroread}
                if($readlength -lt $MaxBufferSize) {
                    $outbuffer = New-Object Byte[] $readlength
                    [byte[]]::Copy($buffer, $outbuffer, $readlength)
                } else {
                    $outbuffer = $buffer
                    $buffer = New-Object Byte[] $MaxBufferSize
                }
                $resultwrapper.Clear()
                $resultwrapper.Add($outbuffer)
                $resultwrapper
                doprogress
            }
        } until($true)
    } finally {
        Write-Progress -Activity 'Get-ByteContent' -Status 'done' -Completed
        $disposerequiredlist |% {$_.Dispose()}
    }
}

function Set-ByteContent {
    <#
    .Synopsis
    バイト列をファイルへ出力 (上書き) する。
    .Parameter LiteralPath
    出力ファイルパスを指定する。
    .Parameter PassThru
    処理中のバイト列を標準出力へ出力する。規定では何も出力しない。
    .Parameter InputObject
    出力するバイト列を指定する。
    #>
    param(
        [Parameter(ParameterSetName='LiteralPath', Position=0)]
        [string] $LiteralPath,
        [Parameter(ParameterSetName='LiteralPath', Position=1)]
        [switch] $PassThru,
        [Parameter(ParameterSetName='LiteralPath', Position=2, Mandatory=$true, ValueFromPipeline=$true)]
        [Byte[]] $InputObject)
    begin {
        $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
        Set-StrictMode -Version 3
        
        $resultwrapper = New-Object System.Collections.Generic.List[byte[]]
        $disposerequiredlist = New-Object System.Collections.Generic.List[System.IDisposable]
        try {
            $tgtstream = Open-FileStream -LiteralPath $LiteralPath -FileMode Create -FileAccess Write -FileShare Read
            $disposerequiredlist.Add($tgtstream)
        } catch {
            $disposerequiredlist |% {$_.Dispose()}
            throw
        }
    }
    process {
        try {
            $start = $InputObject.GetLowerBound(0)
            $length = $InputObject.Length
            $tgtstream.Write($InputObject, $start, $length)
            if($PassThru.IsPresent) {
                $resultwrapper.Clear()
                $resultwrapper.Add($InputObject)
                $resultwrapper
            }
        } catch {
            $disposerequiredlist |% {$_.Dispose()}
            throw
        }
    }
    end {
        $disposerequiredlist |% {$_.Dispose()}
    }
}

function Copy-Stream {
    <#
    .Synopsis
    ストリームとストリームまたはストリームとファイルの間で入出力する。
    .Parameter SourcePath
    コピー元ファイルパスを指定する。
    .Parameter SourceStream
    コピー元ストリームを [System.IO.Stream] 派生クラス インスタンスで指定する。
    .Parameter DestinationPath
    コピー先ファイルパスを指定する。
    .Parameter DestinationStream
    コピー先ストリームを [System.IO.Stream] 派生クラス インスタンスで指定する。
    .Parameter Force
    コピー元ファイルパスを指定した場合に、ファイルが書き込みオープン中でも可
    能な場合は開く。但し、処理中にファイル内容が書き換わると部分的に古い一貫
    性のないコピーが進行し、データが破損するリスクがある。
    .Parameter Close
    処理後に各ストリームを閉じる。
    .Parameter BufferSize
    内部バッファサイズ。既定は 1 MB。
    .Parameter SuppressProgress
    プログレスバーを非表示にする。なお、コピー元ストリームがシーク不可能な場
    合は本オプション指定に関わらずプログレスバーを表示しない。
    .Parameter ShowDotProgress
    処理経過をホストへのドット記号出力で示す。BufferSize でサイズ指定するバッ
    ファを処理するごとに 1 ドットを出力する。コピー元ストリームがシーク不能な
    場合でも経過が出力される。
    #>
    [CmdletBinding(DefaultParametersetName='SourceStreamAndDestinationStream')]
    param(
        [Parameter(Mandatory=$true, ParameterSetName='SourcePathAndDestinationStream', Position=0)]
        [string] $SourcePath,
        [Parameter(Mandatory=$true, ParameterSetName='SourceStreamAndDestinationPath', Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName='SourceStreamAndDestinationStream', Position=0)]
        [System.IO.Stream] $SourceStream,
        [Parameter(Mandatory=$true, ParameterSetName='SourceStreamAndDestinationPath', Position=1)]
        [string] $DestinationPath,
        [Parameter(Mandatory=$true, ParameterSetName='SourcePathAndDestinationStream', Position=1)]
        [Parameter(Mandatory=$true, ParameterSetName='SourceStreamAndDestinationStream', Position=1)]
        [System.IO.Stream] $DestinationStream,
        [Parameter(Mandatory=$false, ParameterSetName='SourcePathAndDestinationStream', Position=2)]
        [switch] $Force,
        [Parameter(Mandatory=$false, ParameterSetName='SourceStreamAndDestinationPath', Position=2)]
        [Parameter(Mandatory=$false, ParameterSetName='SourcePathAndDestinationStream', Position=3)]
        [Parameter(Mandatory=$false, ParameterSetName='SourceStreamAndDestinationStream', Position=2)]
        [switch] $Close,
        [Parameter(Mandatory=$false, ParameterSetName='SourceStreamAndDestinationPath', Position=3)]
        [Parameter(Mandatory=$false, ParameterSetName='SourcePathAndDestinationStream', Position=4)]
        [Parameter(Mandatory=$false, ParameterSetName='SourceStreamAndDestinationStream', Position=3)]
        [int] $BufferSize = (1024*1024),
        [Parameter(Mandatory=$false, ParameterSetName='SourceStreamAndDestinationPath', Position=4)]
        [Parameter(Mandatory=$false, ParameterSetName='SourcePathAndDestinationStream', Position=5)]
        [Parameter(Mandatory=$false, ParameterSetName='SourceStreamAndDestinationStream', Position=4)]
        [switch] $SuppressProgress,
        [Parameter(Mandatory=$false, ParameterSetName='SourceStreamAndDestinationPath', Position=5)]
        [Parameter(Mandatory=$false, ParameterSetName='SourcePathAndDestinationStream', Position=6)]
        [Parameter(Mandatory=$false, ParameterSetName='SourceStreamAndDestinationStream', Position=5)]
        [switch] $ShowDotProgress)
    
    $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
    Set-StrictMode -Version 3
    
    New-Variable -Name MaxBufferSize -Value $BufferSize -Option Constant
    $buffer = New-Object Byte[] $MaxBufferSize
    [int64] $totalread = 0
    [int64] $skipread = 0
    
    $disposerequiredlist = New-Object System.Collections.Generic.List[System.IDisposable]
    try {
        [System.IO.Stream] $source = $null
        [System.IO.Stream] $destination = $null
        
        if($PSCmdlet.ParameterSetName -eq 'SourcePathAndDestinationStream') {
            try {
                $source = Open-FileStream -LiteralPath $SourcePath -FileMode Open -FileAccess Read -FileShare Read
            } catch {
                if($Force.IsPresent -and $null -ne $_.Exception -and $null -ne $_.Exception.InnerException -and $_.Exception.InnerException.GetType() -eq [System.IO.IOException]) { 
                    $source = Open-FileStream -LiteralPath $SourcePath -FileMode Open -FileAccess Read -FileShare ReadWrite
                } else {
                    throw
                }
            }
            $disposerequiredlist.Add($source)
        } else {
            $source = $SourceStream
            if($Close.IsPresent) {
                $disposerequiredlist.Add($source)
            }
        }
        
        if($PSCmdlet.ParameterSetName -match 'SourceStreamAndDestinationPath') {
            $destination = Open-FileStream -LiteralPath $destinationPath -FileMode Create -FileAccess Write -FileShare Read
            $disposerequiredlist.Add($destination)
        } else {
            $destination = $DestinationStream
            if($Close.IsPresent) {
                $disposerequiredlist.Add($destination)
            }
        }
        
        # for progress
        $refreshprogress = [datetime]::MaxValue
        $showprogress = $false
        [long] $totallength = 0
        if(-not $SuppressProgress.IsPresent -and $source.CanSeek) {
            $totallength = $source.Length -$source.Position
            $refreshprogress = [datetime]::Now +[timespan]::FromSeconds(1)
            $showprogress = $true
        }
        if($ShowDotProgress.IsPresent) {
            $showprogress = $true
        }
        
        function doprogress {
            if([datetime]::Now -gt $refreshprogress) {
                $percent = [Math]::Min(($totalread +$skipread) / $totallength * 100, 100)
                Write-Progress -Activity 'Copy-Stream' -Status ('copying... {0:0.0}%' -f $percent) -PercentComplete $percent
                $refreshprogress = [datetime]::Now +[timespan]::FromMilliseconds(100)
            }
            if($ShowDotProgress.IsPresent) {
                Write-Host '.' -NoNewline
            }
        }
        
        $readlength = $MaxBufferSize
        if($showprogress) {
            while($readlength -gt 0) {
                $readlength = $source.Read($buffer, 0, $MaxBufferSize)
                $destination.Write($buffer, 0, $readlength)
                $totalread += $readlength
                doprogress
            }
        } else {
            while($readlength -gt 0) {
                $readlength = $source.Read($buffer, 0, $MaxBufferSize)
                $destination.Write($buffer, 0, $readlength)
            }
        }
    } finally {
        if($showprogress) {
            Write-Progress -Activity 'Copy-Stream' -Status 'copyed' -Completed
        }
        $disposerequiredlist |% {$_.Dispose()}
    }
}

function Hash-ByteContent {
    <#
    .Synopsis
    バイト列のハッシュ値を計算する。
    .Parameter Algorithms
    [System.Security.Cryptography.HashAlgorithm] の派生クラス インスタンスの
    配列でアルゴリズムを指定する。
    .Parameter DisposeAlgorithm
    アルゴリズムを指定した場合に、ハッシュ値の計算後にアルゴリズムを破棄す
    る。
    .Parameter AsString
    計算結果を HEX 文字列で出力する (既定)。明示的にオフにすると、バイト配列
    で出力する。
    .Parameter InputObject
    ハッシュ値を計算するバイト列を指定する。
    #>
    param(
        [Parameter(Position=0)]
        [System.Security.Cryptography.HashAlgorithm[]] $Algorithms,
        [Parameter(Position=1)]
        [switch] $DisposeAlgorithm = $true,
        [Parameter(Position=2)]
        [switch] $AsString = $true,
        [Parameter(Position=3, Mandatory=$true, ValueFromPipeline=$true)]
        [Byte[]] $InputObject)
    begin {
        $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
        Set-StrictMode -Version 3
        
        $DisposeRequiredList = New-Object System.Collections.Generic.List[System.IDisposable]
        try {
            if($null -eq $Algorithms -or $Algorithms.Length -le 0) {
                $Algorithms = New-Object System.Security.Cryptography.HashAlgorithm[] 1
                $Algorithms[0] = New-Object System.Security.Cryptography.SHA1Managed
                if($Algorithms[0] -is [System.IDisposable]) {
                    $DisposeRequiredList.Add($Algorithms[0])
                }
            } else {
                if($DisposeAlgorithm.IsPresent) {
                    $Algorithms |% {
                        if($_ -is [System.IDisposable]) {
                            $DisposeRequiredList.Add($_)
                        }
                    }
                }
            }
            
            $Algorithms |% {$_.Initialize()}
        } catch {
            $DisposeRequiredList |% {$_.Dispose()}
            throw
        }
    }
    process {
        try {
            $Algorithms |% {
                $_.TransformBlock($InputObject, 0, $InputObject.Length, $null, 0) | Out-Null
            }
        } catch {
            $DisposeRequiredList |% {$_.Dispose()}
            throw
        }
    }
    end {
        try {
            $result = New-Object System.Collections.Generic.List[byte[]]
            $Algorithms |% {
                $_.TransformFinalBlock($InputObject, 0, 0) | Out-Null
                $result.Add($_.Hash)
            }
            if($AsString.IsPresent) {
                $result |% {
                    $_ | ConvertFrom-ByteContent
                }
            } else {
                $result
            }
        } finally {
            $DisposeRequiredList |% {$_.Dispose()}
        }
    }
}

function Hash-Stream {
    <#
    .Synopsis
    ストリーム入力のハッシュ値を計算する。
    .Parameter LiteralPath
    入力ファイルパスを指定する。
    .Parameter Stream
    ストリーム入力を [System.IO.Stream] 派生クラス インスタンスで指定する。
    .Parameter Algorithms
    [System.Security.Cryptography.HashAlgorithm] の派生クラス インスタンスの
    配列でアルゴリズムを指定する。
    .Parameter Force
    ファイルパスを指定した場合に、ファイルが書き込みオープン中でも可能な場合
    は開く。但し、処理中にファイル内容が書き換わると不正な計算結果となる。
    .Parameter Close
    ストリームを指定した場合に、ハッシュ値の計算後にストリームを閉じる。
    .Parameter DisposeAlgorithm
    アルゴリズムを指定した場合に、ハッシュ値の計算後にアルゴリズムを破棄す
    る。
    .Parameter AsString
    計算結果を HEX 文字列で出力する (既定)。明示的にオフにすると、バイト配列
    で出力する。
    .Parameter BufferSize
    内部バッファサイズ。既定は 1 MB。
    .Parameter SuppressProgress
    プログレスバーを非表示にする。なお、シーク不可能なストリームの場合は本オ
    プション指定に関わらずプログレスバーを表示しない。
    .Parameter ShowDotProgress
    処理経過をホストへのドット記号出力で示す。BufferSize でサイズ指定するバッ
    ファを処理するごとに 1 ドットを出力する。入力ストリームがシーク不能な場合
    でも経過が出力される。
    #>
    [CmdletBinding(DefaultParametersetName='Stream')]
    param(
        [Parameter(ParameterSetName='LiteralPath', Position=0)]
        [string] $LiteralPath,
        [Parameter(ParameterSetName='Stream', Position=0, ValueFromPipeline=$true)]
        [System.IO.Stream] $Stream,
        [Parameter(ParameterSetName='LiteralPath', Position=1)]
        [Parameter(ParameterSetName='Stream', Position=1)]
        [System.Security.Cryptography.HashAlgorithm[]] $Algorithms,
        [Parameter(ParameterSetName='LiteralPath', Position=2)]
        [switch] $Force,
        [Parameter(ParameterSetName='Stream', Position=2)]
        [switch] $Close,
        [Parameter(ParameterSetName='LiteralPath', Position=3)]
        [Parameter(ParameterSetName='Stream', Position=3)]
        [switch] $DisposeAlgorithm = $true,
        [Parameter(ParameterSetName='LiteralPath', Position=4)]
        [Parameter(ParameterSetName='Stream', Position=4)]
        [switch] $AsString = $true,
        [Parameter(ParameterSetName='LiteralPath', Position=5)]
        [Parameter(ParameterSetName='Stream',      Position=5)]
        [int] $BufferSize = (1024*1024),
        [Parameter(ParameterSetName='LiteralPath', Position=6)]
        [Parameter(ParameterSetName='Stream',      Position=6)]
        [switch] $SuppressProgress,
        [Parameter(ParameterSetName='LiteralPath', Position=7)]
        [Parameter(ParameterSetName='Stream',      Position=7)]
        [switch] $ShowDotProgress)
    
    $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
    Set-StrictMode -Version 3
    
    New-Variable -Name MaxBufferSize -Value $BufferSize -Option Constant
    $buffer = New-Object Byte[] $MaxBufferSize
    [int64] $totalread = 0
    
    $disposerequiredlist = New-Object System.Collections.Generic.List[System.IDisposable]
    try {
        if($null -eq $Algorithms -or $Algorithms.Length -le 0) {
            $Algorithms = New-Object System.Security.Cryptography.HashAlgorithm[] 1
            $Algorithms[0] = New-Object System.Security.Cryptography.SHA1Managed
            $DisposeRequiredList.Add($Algorithms[0])
        } else {
            if($DisposeAlgorithm.IsPresent) {
                $Algorithms |% {
                    $DisposeRequiredList.Add($_)
                }
            }
        }
        
        $Algorithms |% {$_.Initialize()}
        
        switch($PsCmdlet.ParameterSetName) {
            'Stream' {
                $tgtstream = $Stream
                if($Close.IsPresent) {
                    $disposerequiredlist.Add($tgtstream)
                }
            }
            default {
                try {
                    $tgtstream = Open-FileStream -LiteralPath $LiteralPath -FileMode Open -FileAccess Read -FileShare Read
                } catch {
                    if($Force.IsPresent -and $null -ne $_.Exception -and $null -ne $_.Exception.InnerException -and $_.Exception.InnerException.GetType() -eq [System.IO.IOException]) {
                        $tgtstream = Open-FileStream -LiteralPath $LiteralPath -FileMode Open -FileAccess Read -FileShare ReadWrite
                    } else {
                        throw
                    }
                }
                $disposerequiredlist.Add($tgtstream)
            }
        }
        
        # for progress
        $refreshprogress = [datetime]::MaxValue
        $showprogress = $false
        [long] $totallength = 0
        if(-not $SuppressProgress.IsPresent -and $tgtstream.CanSeek) {
            $totallength = $tgtstream.Length -$tgtstream.Position
            $refreshprogress = [datetime]::Now +[timespan]::FromSeconds(1)
            $showprogress = $true
        }
        if($ShowDotProgress.IsPresent) {
            $showprogress = $true
        }
        
        function doprogress {
            if([datetime]::Now -gt $refreshprogress) {
                $percent = [Math]::Min($totalread / $totallength * 100, 100)
                Write-Progress -Activity 'Hash-Stream' -Status ('calclating... {0:0.0}%' -f $percent) -PercentComplete $percent
                $refreshprogress = [datetime]::Now +[timespan]::FromMilliseconds(100)
            }
            if($ShowDotProgress.IsPresent) {
                Write-Host '.' -NoNewline
            }
        }
        
        $readlength = $MaxBufferSize
        if($showprogress) {
            while($readlength -gt 0) {
                $readlength = $tgtstream.Read($buffer, 0, $MaxBufferSize)
                $totalread += $readlength
                $Algorithms |% {
                    $_.TransformBlock($buffer, 0, $readlength, $null, 0) | Out-Null
                }
                doprogress
            }
        } else {
            while($readlength -gt 0) {
                $readlength = $tgtstream.Read($buffer, 0, $MaxBufferSize)
                $Algorithms |% {
                    $_.TransformBlock($buffer, 0, $readlength, $null, 0) | Out-Null
                }
            }
        }
        
        $result = New-Object System.Collections.Generic.List[byte[]]
        $Algorithms |% {
            $_.TransformFinalBlock($buffer, 0, 0) | Out-Null
            $result.Add($_.Hash)
        }
        if($AsString.IsPresent) {
            $result |% {
                $_ | ConvertFrom-ByteContent
            }
        } else {
            $result
        }
    } finally {
        Write-Progress -Activity 'Hash-Stream' -Status 'calclated' -Completed
        $disposerequiredlist |% {$_.Dispose()}
    }
}

function Dump-ByteContent {
    <#
    .Synopsis
    バイト列をコンソール向けに出力する。
    .Parameter StartAddress
    開始アドレスを指定する。
    .Parameter Address64
    アドレス列を 64 ビット表示にする。デフォルトは 32 ビット。
    .Parameter Capital
    16 進数を大文字で出力する。デフォルトは小文字。
    .Parameter BytesPerLine
    1 行に出力するバイト数を 8 の倍数で指定する。デフォルトは 8。
    .Parameter Encoding
    テキスト表示するときのエンコーディング。[System.Text.Encoding] の派生ク
    ラスを指定する。$null を明示するとテキスト表示をしない。デフォルトは
    UTF8。
    .Parameter RawCombiningChar
    テキスト表示するとき、結合文字をそのまま出力する。デフォルトは結合文字の
    直前にゼロ幅スペース (U+200b) を挿入し、基底文字と結合文字が結合されずそ
    れぞれ出力されるようにする。
    .Parameter RawSurrogate
    テキスト表示するとき、サロゲート文字をそのまま出力する。デフォルトは四角
    記号 "□" に置き換える。
    .Parameter PrintableOnly
    テキスト表示するとき、結合文字およびサロゲート文字をピリオド記号 "." へ
    置き換える。RawCombiningChar および RawSurrogate と排他。
    .Parameter InputObject
    表示するバイト列を指定する。
    .Example 
    #>
    [CmdletBinding(DefaultParametersetName='FullUnicode')]
    param(
        [Parameter(Position=0)] [Int64]  $StartAddress,
        [Parameter(Position=1)] [switch] $Address64,
        [Parameter(Position=2)] [switch] $Capital,
        [Parameter(Position=3)] [int]    $BytesPerLine = 16,
        [Parameter(Position=4)] [System.Text.Encoding] $Encoding = [System.Text.Encoding]::UTF8,
        [Parameter(ParameterSetName='FullUnicode', Position=5)]
        [switch] $RawCombiningChar,
        [Parameter(ParameterSetName='FullUnicode', Position=6)]
        [switch] $RawSurrogate,
        [Parameter(ParameterSetName='PrintableOnly', Position=5)]
        [switch] $PrintableOnly,
        [Parameter(ParameterSetName='FullUnicode',   Position=7, Mandatory=$true, ValueFromPipeline=$true)]
        [Parameter(ParameterSetName='PrintableOnly', Position=6, Mandatory=$true, ValueFromPipeline=$true)]
        [Byte[]] $InputObject)
    begin {
        $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
        Set-StrictMode -Version 3
        
        if($BytesPerLine % 8 -ne 0) {
            Write-Error -ErrorRecord (New-Object System.Management.Automation.ErrorRecord (New-Object System.ArgumentException 'BytesPerLine must be a multiple 8.'), $null, ([System.Management.Automation.ErrorCategory]::InvalidArgument), 'BytesPerLine')
        }
        
        $bytesplitter = ' '
        $bytesplitterlength = $bytesplitter.Length
        $eightbytesplitter = ' - '
        $eightbytesplitterlength = $eightbytesplitter.Length
        $textsplitter = ' : '
        $breakcharcount = 0
        
        if($Address64.IsPresent) {
            $addressformat = '{0:x16} : '
        } else {
            $addressformat = '{0:x8} : '
        }
        $elementformat = '{0:x2}'
        $elementformatlength = 2
        if($Capital.IsPresent) {
            $addressformat = $addressformat.ToUpper()
            $elementformat = $elementformat.ToUpper()
        }
        
        $bytestring = New-Object System.Collections.Generic.List[string]
        
        $chararray   = $null
        $decodedtext = $null
        $bytereadcount = 0
        $bytecountperline = 0
        $stemcharlength = [int]::MaxValue
        $stemstrinfolength = [int]::MaxValue
        if($null -ne $Encoding) {
            $decoder     = $Encoding.GetDecoder()
            $chararray   = New-Object char[] 16
            $decodedtext = New-Object System.Text.StringBuilder ($BytesPerLine*2)
        }
        function dodecodedchars {
            for($ix = 0; $ix -lt $decodecount; ++$ix) {
                switch ([char]::GetUnicodeCategory($chararray[$ix])) {
                    ([System.Globalization.UnicodeCategory]::Control) {
                        if($PrintableOnly.IsPresent) {
                            [void] $decodedtext.Append('.')
                        } else {
                            switch ($chararray[$ix].ToInt32($null)) {
                                {$_ -lt 0x20} {
                                    [void] $decodedtext.Append([char] ($_ +0x2400))
                                }
                                0x7f {
                                    [void] $decodedtext.Append([char] 0x2421)
                                }
                                default {
                                    [void] $decodedtext.Append('･')
                                }
                            }
                        }
                    }
                    ([System.Globalization.UnicodeCategory]::NonSpacingMark) {
                        if($PrintableOnly.IsPresent) {
                            [void] $decodedtext.Append('.')
                        } else {
                            if(-not $RawCombiningChar) {
                                [void] $decodedtext.Append([char] 0x200b)
                            }
                            [void] $decodedtext.Append($chararray[$ix])
                        }
                    }
                    ([System.Globalization.UnicodeCategory]::SpacingCombiningMark) {
                        if($PrintableOnly.IsPresent) {
                            [void] $decodedtext.Append('.')
                        } else {
                            if(-not $RawCombiningChar) {
                                [void] $decodedtext.Append([char] 0x200b)
                            }
                            [void] $decodedtext.Append($chararray[$ix])
                        }
                    }
                    ([System.Globalization.UnicodeCategory]::Surrogate) {
                        if($PrintableOnly.IsPresent) {
                            [void] $decodedtext.Append('.')
                        } else {
                            if($RawSurrogate) {
                                [void] $decodedtext.Append($chararray[$ix])
                            } else {
                                [void] $decodedtext.Append('□')
                            }
                        }
                    }
                    default {
                        [void] $decodedtext.Append($chararray[$ix])
                    }
                }
            }
        }
        
        [int64] $address = [math]::Floor($StartAddress /$BytesPerLine) *$BytesPerLine
        $outbuff = New-Object System.Text.StringBuilder 80
        
        for($ix = $StartAddress -$address; $ix -gt 0; --$ix) {
            if($address % $BytesPerLine -eq 0) {
                if($outbuff.Length -gt 0) {
                    $bytestring.Add($outbuff.ToString())
                    $outbuff.Clear() | Out-Null
                }
                $outbuff.AppendFormat($addressformat, $address) | Out-Null
                $outbuff.AppendFormat("{0,$($elementformatlength)}", ' ') | Out-Null
            } elseif($address % 8 -eq 0) {
                $outbuff.AppendFormat("{0,$($eightbytesplitterlength +$elementformatlength)}", ' ') | Out-Null
            } else {
                $outbuff.AppendFormat("{0,$($bytesplitterlength +$elementformatlength)}", ' ') | Out-Null
            }
            ++$bytecountperline
            ++$address
        }
        if($Encoding -ne $null -and  $bytecountperline -eq $BytesPerLine -1) {
            $stemcharlength = $decodedtext.Length
        }
    }
    process {
        for($localbytecount = 0; $localbytecount -lt $InputObject.Length; ++$localbytecount) {
            if($address % $BytesPerLine -eq 0) {
                $outbuff.AppendFormat($addressformat, $address) | Out-Null
            } elseif($address % 8 -eq 0) {
                $outbuff.Append($eightbytesplitter) | Out-Null
            } else {
                $outbuff.Append($bytesplitter) | Out-Null
            }
            
            $outbuff.AppendFormat($elementformat, $InputObject[$localbytecount]) | Out-Null
            
            ++$address
            
            if($address % $BytesPerLine -eq 0) {
                $bytestring.Add($outbuff.ToString())
                $outbuff.Clear() | Out-Null
            }
            
            if($null -eq $Encoding) {
                $bytestring
                $bytestring.Clear()
            } else {
                $decodecount = $decoder.GetChars($InputObject, $localbytecount, 1, $chararray, 0)
                ++$bytecountperline
                if($bytecountperline -eq $BytesPerLine) {
                    $stemcharlength = $decodedtext.Length
                }
                if($decodecount -gt 0) {
                    dodecodedchars
                    if($stemstrinfolength -lt [int]::MaxValue) {
                        $decodedstrinfo = [System.Globalization.StringInfo]::ParseCombiningCharacters($decodedtext.ToString())
                        if($decodedstrinfo.Length -gt $stemstrinfolength) {
                            $rmpos = $decodedstrinfo[$stemstrinfolength]
                            
                            '{0}{2}{1}' -f $bytestring[0], $decodedtext.ToString(0, $rmpos), $textsplitter
                            [void] $decodedtext.Remove(0, $rmpos)
                            $bytestring.RemoveAt(0)
                            if($bytestring.Count -gt 0) {
                                $bytestring
                                $bytestring.Clear()
                            }
                            
                            $bytecountperline = $bytecountperline % $BytesPerLine
                            if($bytecountperline -eq $BytesPerLine -1) {
                                $stemcharlength = $decodedtext.Length
                            }
                            $stemstrinfolength = [int]::MaxValue
                        }
                    } elseif($stemcharlength -lt $decodedtext.Length) {
                        $stemcharlength = [int]::MaxValue
                        $stemstrinfolength = [System.Globalization.StringInfo]::ParseCombiningCharacters($decodedtext.ToString()).Length
                    }
                }
            }
        }
    }
    end {
        if($null -ne $Encoding) {
            $decodecount = $decoder.GetChars($InputObject, 0, 0, $chararray, 0, $true)
            dodecodedchars
            
            while($address % $BytesPerLine -ne 0) {
                if($address % 8 -eq 0) {
                    $outbuff.AppendFormat("{0,$($eightbytesplitterlength +$elementformatlength)}", ' ') | Out-Null
                } else {
                    $outbuff.AppendFormat("{0,$($bytesplitterlength +$elementformatlength)}", ' ') | Out-Null
                }
                ++$address
            }
            if($outbuff.Length -gt 0) {
                $bytestring.Add($outbuff.ToString())
                $outbuff.Clear() | Out-Null
            }
            if($bytestring.Count -gt 0) {
                '{0}{2}{1}' -f $bytestring[0], $decodedtext.ToString(), $textsplitter
                $bytestring.RemoveAt(0)
                if($bytestring.Count -gt 0) {
                    $bytestring
                    $bytestring.Clear()
                }
            }
        } else {
            if($outbuff.Length -gt 0) {
                $bytestring.Add($outbuff.ToString())
            }
            if($bytestring.Count -gt 0) {
                $bytestring
            }
        }
    }
}
