& {
$encoding = [System.Text.Encoding]::UTF8

[void] $tgttext.Clear()
[void] $tgttext.Append('[')
[void] $tgttext.Append('ぱ')
[void] $tgttext.Append('は')
[void] $tgttext.Append([char] 0x309a) # 結合文字の半濁点
[void] $tgttext.Append(']')

$result = Dump-ByteContent -Encoding $encoding -RawCombiningChar -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b e3 81 b1 e3 81 af e3 - 82 9a 5d                : [ぱぱ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 7 -Encoding $encoding -RawCombiningChar -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                      5b - e3 81 b1 e3 81 af e3 82 : [ぱぱ
00000010 : 9a 5d                                             : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -RawCombiningChar -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b e3 81 b1 e3 : [ぱぱ
00000010 : 81 af e3 82 9a 5d                                 : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b e3 81 b1 e3 81 af e3 - 82 9a 5d                : [ぱは​゚]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 7 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                      5b - e3 81 b1 e3 81 af e3 82 : [ぱは​゚
00000010 : 9a 5d                                             : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b e3 81 b1 e3 : [ぱは
00000010 : 81 af e3 82 9a 5d                                 : ​゚]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b e3 81 b1 e3 81 af e3 - 82 9a 5d                : [ぱは.]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 7 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                      5b - e3 81 b1 e3 81 af e3 82 : [ぱは.
00000010 : 9a 5d                                             : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b e3 81 b1 e3 : [ぱは
00000010 : 81 af e3 82 9a 5d                                 : .]
'@ -replace '\r?\n', "`n"))


[void] $tgttext.Clear()
[void] $tgttext.Append('[')
[void] $tgttext.Append([char] 0x01D6) # ǖ
[void] $tgttext.Append([char] 0x00FC) # ü
[void] $tgttext.Append([char] 0x0304) # ̄ (結合文字)
[void] $tgttext.Append([char] 0x0075) # u
[void] $tgttext.Append([char] 0x0308) # ̈ (結合文字)
[void] $tgttext.Append([char] 0x0304) # ̄ (結合文字)
[void] $tgttext.Append(']')

$result = Dump-ByteContent -Encoding $encoding -RawCombiningChar -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b c7 96 c3 bc cc 84 75 - cc 88 cc 84 5d          : [ǖǖǖ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 5 -Encoding $encoding -RawCombiningChar -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                5b c7 96 - c3 bc cc 84 75 cc 88 cc : [ǖǖǖ
00000010 : 84 5d                                             : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 8 -Encoding $encoding -RawCombiningChar -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                         - 5b c7 96 c3 bc cc 84 75 : [ǖǖǖ
00000010 : cc 88 cc 84 5d                                    : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b c7 96 c3 bc cc 84 75 - cc 88 cc 84 5d          : [ǖü​̄u​̈​̄]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 5 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                5b c7 96 - c3 bc cc 84 75 cc 88 cc : [ǖü​̄u​̈​̄
00000010 : 84 5d                                             : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 8 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                         - 5b c7 96 c3 bc cc 84 75 : [ǖü​̄u
00000010 : cc 88 cc 84 5d                                    : ​̈​̄]
'@ -replace '\r?\n', "`n"))


$result = Dump-ByteContent -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b c7 96 c3 bc cc 84 75 - cc 88 cc 84 5d          : [ǖü.u..]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 5 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                5b c7 96 - c3 bc cc 84 75 cc 88 cc : [ǖü.u..
00000010 : 84 5d                                             : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 8 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                         - 5b c7 96 c3 bc cc 84 75 : [ǖü.u
00000010 : cc 88 cc 84 5d                                    : ..]
'@ -replace '\r?\n', "`n"))

}
