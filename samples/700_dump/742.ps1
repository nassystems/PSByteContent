& {
$encoding = [System.Text.Encoding]::Unicode

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes('いろはにほへとちりぬるをわかよたれそつねならむうゐのおくやまけふこえてあさきゆめみしゑひもせす')
Assert ($result -join "`n" -ceq (@'
00000000 : 44 30 8d 30 6f 30 6b 30 - 7b 30 78 30 68 30 61 30 : いろはにほへとち
00000010 : 8a 30 6c 30 8b 30 92 30 - 8f 30 4b 30 88 30 5f 30 : りぬるをわかよた
00000020 : 8c 30 5d 30 64 30 6d 30 - 6a 30 89 30 80 30 46 30 : れそつねならむう
00000030 : 90 30 6e 30 4a 30 4f 30 - 84 30 7e 30 51 30 75 30 : ゐのおくやまけふ
00000040 : 53 30 48 30 66 30 42 30 - 55 30 4d 30 86 30 81 30 : こえてあさきゆめ
00000050 : 7f 30 57 30 91 30 72 30 - 82 30 5b 30 59 30       : みしゑひもせす
'@ -replace '\r?\n', "`n"))


# 二点之繞と一点之繞辻 (辻辻󠄀)
[void] $tgttext.Clear()
[void] $tgttext.Append('[')
[void] $tgttext.Append('辻')
[void] $tgttext.Append('辻')
[void] $tgttext.Append([char] 0xdb40)
[void] $tgttext.Append([char] 0xdd00)
[void] $tgttext.Append(']')

$result = Dump-ByteContent -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b 00 bb 8f bb 8f 40 db - 00 dd 5d 00             : [辻辻󠄀]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 6 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                   5b 00 - bb 8f bb 8f 40 db 00 dd : [辻辻󠄀
00000010 : 5d 00                                             : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 7 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                      5b - 00 bb 8f bb 8f 40 db 00 : [辻辻󠄀
00000010 : dd 5d 00                                          : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b 00 bb 8f bb : [辻辻󠄀
00000010 : 8f 40 db 00 dd 5d 00                              : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 12 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                       5b 00 bb 8f : [辻
00000010 : bb 8f 40 db 00 dd 5d 00                           : 辻󠄀]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b 00 bb 8f bb 8f 40 db - 00 dd 5d 00             : [辻辻□□]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 6 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                   5b 00 - bb 8f bb 8f 40 db 00 dd : [辻辻□□
00000010 : 5d 00                                             : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 7 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                      5b - 00 bb 8f bb 8f 40 db 00 : [辻辻□□
00000010 : dd 5d 00                                          : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b 00 bb 8f bb : [辻辻
00000010 : 8f 40 db 00 dd 5d 00                              : □□]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 12 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                       5b 00 bb 8f : [辻
00000010 : bb 8f 40 db 00 dd 5d 00                           : 辻□□]
'@ -replace '\r?\n', "`n"))


$result = Dump-ByteContent -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b 00 bb 8f bb 8f 40 db - 00 dd 5d 00             : [辻辻..]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 6 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                   5b 00 - bb 8f bb 8f 40 db 00 dd : [辻辻..
00000010 : 5d 00                                             : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 7 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                      5b - 00 bb 8f bb 8f 40 db 00 : [辻辻..
00000010 : dd 5d 00                                          : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b 00 bb 8f bb : [辻辻
00000010 : 8f 40 db 00 dd 5d 00                              : ..]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 12 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                       5b 00 bb 8f : [辻
00000010 : bb 8f 40 db 00 dd 5d 00                           : 辻..]
'@ -replace '\r?\n', "`n"))


$result = Dump-ByteContent -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 : 67 d8 3d de 20 00 28 00 - 7b 30 63 30 51 30 29 00 : 𩸽 (ほっけ)
00000010 : 20 00 68 30 20 00 67 d8 - 49 de 20 00 28 00 68 30 :  と 𩹉 (と
00000020 : 73 30 46 30 4a 30 29 00                           : びうお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 15 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                                67 : 𩸽
00000010 : d8 3d de 20 00 28 00 7b - 30 63 30 51 30 29 00 20 :  (ほっけ) 
00000020 : 00 68 30 20 00 67 d8 49 - de 20 00 28 00 68 30 73 : と 𩹉 (とび
00000030 : 30 46 30 4a 30 29 00                              : うお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 13 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                          67 d8 3d : 𩸽
00000010 : de 20 00 28 00 7b 30 63 - 30 51 30 29 00 20 00 68 :  (ほっけ) と
00000020 : 30 20 00 67 d8 49 de 20 - 00 28 00 68 30 73 30 46 :  𩹉 (とびう
00000030 : 30 4a 30 29 00                                    : お)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 : 67 d8 3d de 20 00 28 00 - 7b 30 63 30 51 30 29 00 : □□ (ほっけ)
00000010 : 20 00 68 30 20 00 67 d8 - 49 de 20 00 28 00 68 30 :  と □□ (と
00000020 : 73 30 46 30 4a 30 29 00                           : びうお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 15 -Encoding $encoding -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                                67 : □□
00000010 : d8 3d de 20 00 28 00 7b - 30 63 30 51 30 29 00 20 :  (ほっけ) 
00000020 : 00 68 30 20 00 67 d8 49 - de 20 00 28 00 68 30 73 : と □□ (とび
00000030 : 30 46 30 4a 30 29 00                              : うお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 13 -Encoding $encoding -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                          67 d8 3d : □□
00000010 : de 20 00 28 00 7b 30 63 - 30 51 30 29 00 20 00 68 :  (ほっけ) と
00000020 : 30 20 00 67 d8 49 de 20 - 00 28 00 68 30 73 30 46 :  □□ (とびう
00000030 : 30 4a 30 29 00                                    : お)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 : 67 d8 3d de 20 00 28 00 - 7b 30 63 30 51 30 29 00 : .. (ほっけ)
00000010 : 20 00 68 30 20 00 67 d8 - 49 de 20 00 28 00 68 30 :  と .. (と
00000020 : 73 30 46 30 4a 30 29 00                           : びうお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 15 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                                67 : ..
00000010 : d8 3d de 20 00 28 00 7b - 30 63 30 51 30 29 00 20 :  (ほっけ) 
00000020 : 00 68 30 20 00 67 d8 49 - de 20 00 28 00 68 30 73 : と .. (とび
00000030 : 30 46 30 4a 30 29 00                              : うお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 13 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                          67 d8 3d : ..
00000010 : de 20 00 28 00 7b 30 63 - 30 51 30 29 00 20 00 68 :  (ほっけ) と
00000020 : 30 20 00 67 d8 49 de 20 - 00 28 00 68 30 73 30 46 :  .. (とびう
00000030 : 30 4a 30 29 00                                    : お)
'@ -replace '\r?\n', "`n"))


# 絵文字はサロゲート文字の集合文字列なので、ParseSurrogate しないと表れない。
# StringInfo でも文字数を正しく取得できないので、改行位置が乱れる。
$result = Dump-ByteContent -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes('🧑🧑🏻🧑🏼🧑🏽🧑🏾🧑🏿')
Assert ($result -join "`n" -eq (@'
00000000 : 3e d8 d1 dd 3e d8 d1 dd - 3c d8 fb df 3e d8 d1 dd : 🧑🧑🏻🧑
00000010 : 3c d8 fc df 3e d8 d1 dd - 3c d8 fd df 3e d8 d1 dd : 🏼🧑🏽🧑
00000020 : 3c d8 fe df 3e d8 d1 dd - 3c d8 ff df             : 🏾🧑🏿
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes('🧑🧑🏻🧑🏼🧑🏽🧑🏾🧑🏿')
Assert ($result -join "`n" -eq (@'
00000000 : 3e d8 d1 dd 3e d8 d1 dd - 3c d8 fb df 3e d8 d1 dd : □□□□□□□□
00000010 : 3c d8 fc df 3e d8 d1 dd - 3c d8 fd df 3e d8 d1 dd : □□□□□□□□
00000020 : 3c d8 fe df 3e d8 d1 dd - 3c d8 ff df             : □□□□□□
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes('🧑🧑🏻🧑🏼🧑🏽🧑🏾🧑🏿')
Assert ($result -join "`n" -eq (@'
00000000 : 3e d8 d1 dd 3e d8 d1 dd - 3c d8 fb df 3e d8 d1 dd : ........
00000010 : 3c d8 fc df 3e d8 d1 dd - 3c d8 fd df 3e d8 d1 dd : ........
00000020 : 3c d8 fe df 3e d8 d1 dd - 3c d8 ff df             : ......
'@ -replace '\r?\n', "`n"))

}
