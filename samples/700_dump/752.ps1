& {
$encoding = [System.Text.Encoding]::Unicode

[void] $tgttext.Clear()
[void] $tgttext.Append('[')
[void] $tgttext.Append('ぱ')
[void] $tgttext.Append('は')
[void] $tgttext.Append([char] 0x309a) # 結合文字の半濁点
[void] $tgttext.Append(']')

$result = Dump-ByteContent -Encoding $encoding -RawCombiningChar -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b 00 71 30 6f 30 9a 30 - 5d 00                   : [ぱぱ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 9 -Encoding $encoding -RawCombiningChar -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                              5b 00 71 30 6f 30 9a : [ぱぱ
00000010 : 30 5d 00                                          : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -RawCombiningChar -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b 00 71 30 6f : [ぱぱ
00000010 : 30 9a 30 5d 00                                    : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b 00 71 30 6f 30 9a 30 - 5d 00                   : [ぱは​゚]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 9 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                              5b 00 71 30 6f 30 9a : [ぱは​゚
00000010 : 30 5d 00                                          : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b 00 71 30 6f : [ぱは
00000010 : 30 9a 30 5d 00                                    : ​゚]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b 00 71 30 6f 30 9a 30 - 5d 00                   : [ぱは.]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 9 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                              5b 00 71 30 6f 30 9a : [ぱは.
00000010 : 30 5d 00                                          : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b 00 71 30 6f : [ぱは
00000010 : 30 9a 30 5d 00                                    : .]
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
00000000 : 5b 00 d6 01 fc 00 04 03 - 75 00 08 03 04 03 5d 00 : [ǖǖǖ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 3 -Encoding $encoding -RawCombiningChar -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :          5b 00 d6 01 fc - 00 04 03 75 00 08 03 04 : [ǖǖǖ
00000010 : 03 5d 00                                          : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 7 -Encoding $encoding -RawCombiningChar -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                      5b - 00 d6 01 fc 00 04 03 75 : [ǖǖǖ
00000010 : 00 08 03 04 03 5d 00                              : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b 00 d6 01 fc 00 04 03 - 75 00 08 03 04 03 5d 00 : [ǖü​̄u​̈​̄]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 3 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :          5b 00 d6 01 fc - 00 04 03 75 00 08 03 04 : [ǖü​̄u​̈​̄
00000010 : 03 5d 00                                          : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 7 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                      5b - 00 d6 01 fc 00 04 03 75 : [ǖü​̄u
00000010 : 00 08 03 04 03 5d 00                              : ​̈​̄]
'@ -replace '\r?\n', "`n"))


$result = Dump-ByteContent -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b 00 d6 01 fc 00 04 03 - 75 00 08 03 04 03 5d 00 : [ǖü.u..]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 3 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :          5b 00 d6 01 fc - 00 04 03 75 00 08 03 04 : [ǖü.u..
00000010 : 03 5d 00                                          : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 7 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                      5b - 00 d6 01 fc 00 04 03 75 : [ǖü.u
00000010 : 00 08 03 04 03 5d 00                              : ..]
'@ -replace '\r?\n', "`n"))

}
