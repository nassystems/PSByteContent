& {
$encoding = [System.Text.Encoding]::UTF8

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes('いろはにほへとちりぬるをわかよたれそつねならむうゐのおくやまけふこえてあさきゆめみしゑひもせす')
Assert ($result -join "`n" -ceq (@'
00000000 : e3 81 84 e3 82 8d e3 81 - af e3 81 ab e3 81 bb e3 : いろはにほへ
00000010 : 81 b8 e3 81 a8 e3 81 a1 - e3 82 8a e3 81 ac e3 82 : とちりぬる
00000020 : 8b e3 82 92 e3 82 8f e3 - 81 8b e3 82 88 e3 81 9f : をわかよた
00000030 : e3 82 8c e3 81 9d e3 81 - a4 e3 81 ad e3 81 aa e3 : れそつねなら
00000040 : 82 89 e3 82 80 e3 81 86 - e3 82 90 e3 81 ae e3 81 : むうゐのお
00000050 : 8a e3 81 8f e3 82 84 e3 - 81 be e3 81 91 e3 81 b5 : くやまけふ
00000060 : e3 81 93 e3 81 88 e3 81 - a6 e3 81 82 e3 81 95 e3 : こえてあさき
00000070 : 81 8d e3 82 86 e3 82 81 - e3 81 bf e3 81 97 e3 82 : ゆめみしゑ
00000080 : 91 e3 81 b2 e3 82 82 e3 - 81 9b e3 81 99          : ひもせす
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
00000000 : 5b e8 be bb e8 be bb f3 - a0 84 80 5d             : [辻辻󠄀]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 5 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                5b e8 be - bb e8 be bb f3 a0 84 80 : [辻辻󠄀
00000010 : 5d                                                : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 6 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                   5b e8 - be bb e8 be bb f3 a0 84 : [辻辻󠄀
00000010 : 80 5d                                             : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b e8 be bb e8 : [辻辻󠄀
00000010 : be bb f3 a0 84 80 5d                              : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 12 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                       5b e8 be bb : [辻
00000010 : e8 be bb f3 a0 84 80 5d                           : 辻󠄀]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b e8 be bb e8 be bb f3 - a0 84 80 5d             : [辻辻□□]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 5 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                5b e8 be - bb e8 be bb f3 a0 84 80 : [辻辻□□
00000010 : 5d                                                : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 6 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                   5b e8 - be bb e8 be bb f3 a0 84 : [辻辻□□
00000010 : 80 5d                                             : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b e8 be bb e8 : [辻辻
00000010 : be bb f3 a0 84 80 5d                              : □□]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 12 -Encoding $encoding -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                       5b e8 be bb : [辻
00000010 : e8 be bb f3 a0 84 80 5d                           : 辻□□]
'@ -replace '\r?\n', "`n"))


$result = Dump-ByteContent -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 : 5b e8 be bb e8 be bb f3 - a0 84 80 5d             : [辻辻..]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 5 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                5b e8 be - bb e8 be bb f3 a0 84 80 : [辻辻..
00000010 : 5d                                                : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 6 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                   5b e8 - be bb e8 be bb f3 a0 84 : [辻辻..
00000010 : 80 5d                                             : ]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 11 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                    5b e8 be bb e8 : [辻辻
00000010 : be bb f3 a0 84 80 5d                              : ..]
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 12 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes($tgttext.ToString())
Assert ($result -join "`n" -ceq (@'
00000000 :                                       5b e8 be bb : [辻
00000010 : e8 be bb f3 a0 84 80 5d                           : 辻..]
'@ -replace '\r?\n', "`n"))


$result = Dump-ByteContent -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 : f0 a9 b8 bd 20 28 e3 81 - bb e3 81 a3 e3 81 91 29 : 𩸽 (ほっけ)
00000010 : 20 e3 81 a8 20 f0 a9 b9 - 89 20 28 e3 81 a8 e3 81 :  と 𩹉 (とび
00000020 : b3 e3 81 86 e3 81 8a 29                           : うお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 15 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                                f0 : 𩸽
00000010 : a9 b8 bd 20 28 e3 81 bb - e3 81 a3 e3 81 91 29 20 :  (ほっけ) 
00000020 : e3 81 a8 20 f0 a9 b9 89 - 20 28 e3 81 a8 e3 81 b3 : と 𩹉 (とび
00000030 : e3 81 86 e3 81 8a 29                              : うお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 13 -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                          f0 a9 b8 : 𩸽
00000010 : bd 20 28 e3 81 bb e3 81 - a3 e3 81 91 29 20 e3 81 :  (ほっけ) と
00000020 : a8 20 f0 a9 b9 89 20 28 - e3 81 a8 e3 81 b3 e3 81 :  𩹉 (とびう
00000030 : 86 e3 81 8a 29                                    : お)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 : f0 a9 b8 bd 20 28 e3 81 - bb e3 81 a3 e3 81 91 29 : □□ (ほっけ)
00000010 : 20 e3 81 a8 20 f0 a9 b9 - 89 20 28 e3 81 a8 e3 81 :  と □□ (とび
00000020 : b3 e3 81 86 e3 81 8a 29                           : うお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 15 -Encoding $encoding -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                                f0 : □□
00000010 : a9 b8 bd 20 28 e3 81 bb - e3 81 a3 e3 81 91 29 20 :  (ほっけ) 
00000020 : e3 81 a8 20 f0 a9 b9 89 - 20 28 e3 81 a8 e3 81 b3 : と □□ (とび
00000030 : e3 81 86 e3 81 8a 29                              : うお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 13 -Encoding $encoding -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                          f0 a9 b8 : □□
00000010 : bd 20 28 e3 81 bb e3 81 - a3 e3 81 91 29 20 e3 81 :  (ほっけ) と
00000020 : a8 20 f0 a9 b9 89 20 28 - e3 81 a8 e3 81 b3 e3 81 :  □□ (とびう
00000030 : 86 e3 81 8a 29                                    : お)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 : f0 a9 b8 bd 20 28 e3 81 - bb e3 81 a3 e3 81 91 29 : .. (ほっけ)
00000010 : 20 e3 81 a8 20 f0 a9 b9 - 89 20 28 e3 81 a8 e3 81 :  と .. (とび
00000020 : b3 e3 81 86 e3 81 8a 29                           : うお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 15 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                                f0 : ..
00000010 : a9 b8 bd 20 28 e3 81 bb - e3 81 a3 e3 81 91 29 20 :  (ほっけ) 
00000020 : e3 81 a8 20 f0 a9 b9 89 - 20 28 e3 81 a8 e3 81 b3 : と .. (とび
00000030 : e3 81 86 e3 81 8a 29                              : うお)
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -StartAddress 13 -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes('𩸽 (ほっけ) と 𩹉 (とびうお)')
Assert ($result -join "`n" -ceq (@'
00000000 :                                          f0 a9 b8 : ..
00000010 : bd 20 28 e3 81 bb e3 81 - a3 e3 81 91 29 20 e3 81 :  (ほっけ) と
00000020 : a8 20 f0 a9 b9 89 20 28 - e3 81 a8 e3 81 b3 e3 81 :  .. (とびう
00000030 : 86 e3 81 8a 29                                    : お)
'@ -replace '\r?\n', "`n"))


# 絵文字はサロゲート文字の集合文字列なので、ParseSurrogate しないと表れない。
# StringInfo でも文字数を正しく取得できないので、改行位置が乱れる。
$result = Dump-ByteContent -Encoding $encoding -RawSurrogate -InputObject $encoding.GetBytes('🧑🧑🏻🧑🏼🧑🏽🧑🏾🧑🏿')
Assert ($result -join "`n" -eq (@'
00000000 : f0 9f a7 91 f0 9f a7 91 - f0 9f 8f bb f0 9f a7 91 : 🧑🧑🏻🧑
00000010 : f0 9f 8f bc f0 9f a7 91 - f0 9f 8f bd f0 9f a7 91 : 🏼🧑🏽🧑
00000020 : f0 9f 8f be f0 9f a7 91 - f0 9f 8f bf             : 🏾🧑🏿
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -InputObject $encoding.GetBytes('🧑🧑🏻🧑🏼🧑🏽🧑🏾🧑🏿')
Assert ($result -join "`n" -eq (@'
00000000 : f0 9f a7 91 f0 9f a7 91 - f0 9f 8f bb f0 9f a7 91 : □□□□□□□□
00000010 : f0 9f 8f bc f0 9f a7 91 - f0 9f 8f bd f0 9f a7 91 : □□□□□□□□
00000020 : f0 9f 8f be f0 9f a7 91 - f0 9f 8f bf             : □□□□□□
'@ -replace '\r?\n', "`n"))

$result = Dump-ByteContent -Encoding $encoding -PrintableOnly -InputObject $encoding.GetBytes('🧑🧑🏻🧑🏼🧑🏽🧑🏾🧑🏿')
Assert ($result -join "`n" -eq (@'
00000000 : f0 9f a7 91 f0 9f a7 91 - f0 9f 8f bb f0 9f a7 91 : ........
00000010 : f0 9f 8f bc f0 9f a7 91 - f0 9f 8f bd f0 9f a7 91 : ........
00000020 : f0 9f 8f be f0 9f a7 91 - f0 9f 8f bf             : ......
'@ -replace '\r?\n', "`n"))

}
