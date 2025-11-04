& {
$result = Dump-ByteContent -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly -InputObject $samplebytelist[$sampleindex]
Assert ($result -join "-" -ceq (@'
00000000 : 65 6f 5f d7 7f be dc 9b - cc f8 f3 36 eb 88 d1 dd : eo_?.??????6????
00000010 : e6 6b 3f a2 c6 e6 2b c3 - 8e 57 37 0c 55 a1 e4 af : ?k????+??W7.U???
'@ -replace '\r?\n', "-"))

$result = Dump-ByteContent -StartAddress 0x00000001 -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly -InputObject $samplebytelist[$sampleindex]
Assert ($result -join "`n" -ceq (@'
00000000 :    65 6f 5f d7 7f be dc - 9b cc f8 f3 36 eb 88 d1 : eo_?.??????6???
00000010 : dd e6 6b 3f a2 c6 e6 2b - c3 8e 57 37 0c 55 a1 e4 : ??k????+??W7.U??
00000020 : af                                                : ?
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 0x0000000f -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly -InputObject $samplebytelist[$sampleindex]
Assert ($result -join "`n" -ceq (@'
00000000 :                                                65 : e
00000010 : 6f 5f d7 7f be dc 9b cc - f8 f3 36 eb 88 d1 dd e6 : o_?.??????6?????
00000020 : 6b 3f a2 c6 e6 2b c3 8e - 57 37 0c 55 a1 e4 af    : k????+??W7.U???
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 0x00000010 -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly -InputObject $samplebytelist[$sampleindex]
Assert ($result -join "`n" -ceq (@'
00000010 : 65 6f 5f d7 7f be dc 9b - cc f8 f3 36 eb 88 d1 dd : eo_?.??????6????
00000020 : e6 6b 3f a2 c6 e6 2b c3 - 8e 57 37 0c 55 a1 e4 af : ?k????+??W7.U???
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 0x00000011 -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly -InputObject $samplebytelist[$sampleindex]
Assert ($result -join "`n" -ceq (@'
00000010 :    65 6f 5f d7 7f be dc - 9b cc f8 f3 36 eb 88 d1 : eo_?.??????6???
00000020 : dd e6 6b 3f a2 c6 e6 2b - c3 8e 57 37 0c 55 a1 e4 : ??k????+??W7.U??
00000030 : af                                                : ?
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -BytesPerLine 24 -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly -InputObject $samplebytelist[$sampleindex]
Assert ($result -join "`n" -ceq (@'
00000000 : 65 6f 5f d7 7f be dc 9b - cc f8 f3 36 eb 88 d1 dd - e6 6b 3f a2 c6 e6 2b c3 : eo_?.??????6?????k????+?
00000018 : 8e 57 37 0c 55 a1 e4 af                                                     : ?W7.U???
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 0x00000017 -BytesPerLine 24 -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly -InputObject $samplebytelist[$sampleindex]
Assert ($result -join "`n" -ceq (@'
00000000 :                                                                          65 : e
00000018 : 6f 5f d7 7f be dc 9b cc - f8 f3 36 eb 88 d1 dd e6 - 6b 3f a2 c6 e6 2b c3 8e : o_?.??????6?????k????+??
00000030 : 57 37 0c 55 a1 e4 af                                                        : W7.U???
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 0x00000018 -BytesPerLine 24 -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly -InputObject $samplebytelist[$sampleindex]
Assert ($result -join "`n" -ceq (@'
00000018 : 65 6f 5f d7 7f be dc 9b - cc f8 f3 36 eb 88 d1 dd - e6 6b 3f a2 c6 e6 2b c3 : eo_?.??????6?????k????+?
00000030 : 8e 57 37 0c 55 a1 e4 af                                                     : ?W7.U???
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 0x00000019 -BytesPerLine 24 -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly -InputObject $samplebytelist[$sampleindex]
Assert ($result -join "`n" -ceq (@'
00000018 :    65 6f 5f d7 7f be dc - 9b cc f8 f3 36 eb 88 d1 - dd e6 6b 3f a2 c6 e6 2b : eo_?.??????6?????k????+
00000030 : c3 8e 57 37 0c 55 a1 e4 - af                                                : ??W7.U???
'@ -replace '\r?\n', "`n"))

}
