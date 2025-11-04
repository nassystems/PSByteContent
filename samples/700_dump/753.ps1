& {
$encoding = [System.Text.Encoding]::GetEncoding('shift_jis')

[void] $tgttext.Clear()
[void] $tgttext.Append('[')
[void] $tgttext.Append('ぱ')
[void] $tgttext.Append('は')
[void] $tgttext.Append([char] 0x309a) # 結合文字の半濁点
[void] $tgttext.Append(']')

$result = Dump-ByteContent -Encoding $encoding -RawCombiningChar -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b 82 cf 82 cd 3f 5d                              : [ぱは?]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -RawCombiningChar -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b 82 cf 82 cd : [ぱは
00000010 : 3f 5d                                             : ?]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 12 -Encoding $encoding -RawCombiningChar -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                       5b 82 cf 82 : [ぱは
00000010 : cd 3f 5d                                          : ?]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b 82 cf 82 cd 3f 5d                              : [ぱは?]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b 82 cf 82 cd : [ぱは
00000010 : 3f 5d                                             : ?]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 12 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                       5b 82 cf 82 : [ぱは
00000010 : cd 3f 5d                                          : ?]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b 82 cf 82 cd 3f 5d                              : [ぱは?]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b 82 cf 82 cd : [ぱは
00000010 : 3f 5d                                             : ?]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 12 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                       5b 82 cf 82 : [ぱは
00000010 : cd 3f 5d                                          : ?]
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
00000000 : 5b 3f 75 3f 75 3f 3f 5d                           : [?u?u??]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 10 -Encoding $encoding -RawCombiningChar -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                 5b 3f 75 3f 75 3f : [?u?u?
00000010 : 3f 5d                                             : ?]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -RawCombiningChar -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b 3f 75 3f 75 : [?u?u
00000010 : 3f 3f 5d                                          : ??]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b 3f 75 3f 75 3f 3f 5d                           : [?u?u??]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 10 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                 5b 3f 75 3f 75 3f : [?u?u?
00000010 : 3f 5d                                             : ?]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b 3f 75 3f 75 : [?u?u
00000010 : 3f 3f 5d                                          : ??]
'@ -replace '\r?\n', "`n"))


$result = Dump-ByteContent -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b 3f 75 3f 75 3f 3f 5d                           : [?u?u??]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 10 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                 5b 3f 75 3f 75 3f : [?u?u?
00000010 : 3f 5d                                             : ?]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b 3f 75 3f 75 : [?u?u
00000010 : 3f 3f 5d                                          : ??]
'@ -replace '\r?\n', "`n"))

}
