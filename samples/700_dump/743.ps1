& {
$encoding = [System.Text.Encoding]::GetEncoding('shift_jis')

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes('いろはにほへとちりぬるをわかよたれそつねならむうゐのおくやまけふこえてあさきゆめみしゑひもせす')
Assert ($result -join "`n" -ceq (@'
00000000 : 82 a2 82 eb 82 cd 82 c9 - 82 d9 82 d6 82 c6 82 bf : いろはにほへとち
00000010 : 82 e8 82 ca 82 e9 82 f0 - 82 ed 82 a9 82 e6 82 bd : りぬるをわかよた
00000020 : 82 ea 82 bb 82 c2 82 cb - 82 c8 82 e7 82 de 82 a4 : れそつねならむう
00000030 : 82 ee 82 cc 82 a8 82 ad - 82 e2 82 dc 82 af 82 d3 : ゐのおくやまけふ
00000040 : 82 b1 82 a6 82 c4 82 a0 - 82 b3 82 ab 82 e4 82 df : こえてあさきゆめ
00000050 : 82 dd 82 b5 82 ef 82 d0 - 82 e0 82 b9 82 b7       : みしゑひもせす
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
00000000 : 5b 92 d2 92 d2 3f 3f 5d                           : [辻辻??]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 9 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                              5b 92 d2 92 d2 3f 3f : [辻辻??
00000010 : 5d                                                : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 10 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                 5b 92 d2 92 d2 3f : [辻辻?
00000010 : 3f 5d                                             : ?]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 12 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                       5b 92 d2 92 : [辻辻
00000010 : d2 3f 3f 5d                                       : ??]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 13 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                          5b 92 d2 : [辻
00000010 : 92 d2 3f 3f 5d                                    : 辻??]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b 92 d2 92 d2 3f 3f 5d                           : [辻辻??]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 9 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                              5b 92 d2 92 d2 3f 3f : [辻辻??
00000010 : 5d                                                : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 10 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                 5b 92 d2 92 d2 3f : [辻辻?
00000010 : 3f 5d                                             : ?]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 12 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                       5b 92 d2 92 : [辻辻
00000010 : d2 3f 3f 5d                                       : ??]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 13 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                          5b 92 d2 : [辻
00000010 : 92 d2 3f 3f 5d                                    : 辻??]
'@ -replace '\r?\n', "`n"))


$result = Dump-ByteContent -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b 92 d2 92 d2 3f 3f 5d                           : [辻辻??]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 9 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                              5b 92 d2 92 d2 3f 3f : [辻辻??
00000010 : 5d                                                : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 10 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                 5b 92 d2 92 d2 3f : [辻辻?
00000010 : 3f 5d                                             : ?]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 12 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                       5b 92 d2 92 : [辻辻
00000010 : d2 3f 3f 5d                                       : ??]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 13 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                          5b 92 d2 : [辻
00000010 : 92 d2 3f 3f 5d                                    : 辻??]
'@ -replace '\r?\n', "`n"))


$result = Dump-ByteContent -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 : 3f 3f 20 28 82 d9 82 c1 - 82 af 29 20 82 c6 20 3f : ?? (ほっけ) と ?
00000010 : 3f 20 28 82 c6 82 d1 82 - a4 82 a8 29             : ? (とびうお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 15 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                                3f : ?
00000010 : 3f 20 28 82 d9 82 c1 82 - af 29 20 82 c6 20 3f 3f : ? (ほっけ) と ??
00000020 : 20 28 82 c6 82 d1 82 a4 - 82 a8 29                :  (とびうお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 14 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                             3f 3f : ??
00000010 : 20 28 82 d9 82 c1 82 af - 29 20 82 c6 20 3f 3f 20 :  (ほっけ) と ?? 
00000020 : 28 82 c6 82 d1 82 a4 82 - a8 29                   : (とびうお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 : 3f 3f 20 28 82 d9 82 c1 - 82 af 29 20 82 c6 20 3f : ?? (ほっけ) と ?
00000010 : 3f 20 28 82 c6 82 d1 82 - a4 82 a8 29             : ? (とびうお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 15 -Encoding $encoding -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                                3f : ?
00000010 : 3f 20 28 82 d9 82 c1 82 - af 29 20 82 c6 20 3f 3f : ? (ほっけ) と ??
00000020 : 20 28 82 c6 82 d1 82 a4 - 82 a8 29                :  (とびうお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 14 -Encoding $encoding -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                             3f 3f : ??
00000010 : 20 28 82 d9 82 c1 82 af - 29 20 82 c6 20 3f 3f 20 :  (ほっけ) と ?? 
00000020 : 28 82 c6 82 d1 82 a4 82 - a8 29                   : (とびうお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 : 3f 3f 20 28 82 d9 82 c1 - 82 af 29 20 82 c6 20 3f : ?? (ほっけ) と ?
00000010 : 3f 20 28 82 c6 82 d1 82 - a4 82 a8 29             : ? (とびうお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 15 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                                3f : ?
00000010 : 3f 20 28 82 d9 82 c1 82 - af 29 20 82 c6 20 3f 3f : ? (ほっけ) と ??
00000020 : 20 28 82 c6 82 d1 82 a4 - 82 a8 29                :  (とびうお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 14 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                             3f 3f : ??
00000010 : 20 28 82 d9 82 c1 82 af - 29 20 82 c6 20 3f 3f 20 :  (ほっけ) と ?? 
00000020 : 28 82 c6 82 d1 82 a4 82 - a8 29                   : (とびうお)
'@ -replace '\r?\n', "`n"))

<# shift-jis に絵文字はないのでテスト不能
# 絵文字はサロゲート文字の集合文字列なので、ParseSurrogate しないと表れない。
# StringInfo でも文字数を正しく取得できないので、改行位置が乱れる。
$result = Dump-ByteContent -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes('🧑🧑🏻🧑🏼🧑🏽🧑🏾🧑🏿')
Assert ($result -join "`n" -eq (@'
00000000 : 3f 3f 3f 3f 3f 3f 3f 3f - 3f 3f 3f 3f 3f 3f 3f 3f : ????????????????
00000010 : 3f 3f 3f 3f 3f 3f                                 : ??????
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes('🧑🧑🏻🧑🏼🧑🏽🧑🏾🧑🏿')
Assert ($result -join "`n" -eq (@'
00000000 : 3f 3f 3f 3f 3f 3f 3f 3f - 3f 3f 3f 3f 3f 3f 3f 3f : ????????????????
00000010 : 3f 3f 3f 3f 3f 3f                                 : ??????
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes('🧑🧑🏻🧑🏼🧑🏽🧑🏾🧑🏿')
Assert ($result -join "`n" -eq (@'
00000000 : 3f 3f 3f 3f 3f 3f 3f 3f - 3f 3f 3f 3f 3f 3f 3f 3f : ????????????????
00000010 : 3f 3f 3f 3f 3f 3f                                 : ??????
'@ -replace '\r?\n', "`n"))
#>
}
