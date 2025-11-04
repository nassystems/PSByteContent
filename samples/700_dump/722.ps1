& {
$result = $arraywrapper | Dump-ByteContent -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly
Assert ($result -join "`n" -ceq (@'
00000000 : ac 5b 0c ec 23 78 5c 75 - ab 97 14 da c6 f8 f7 2b : ?[.?#x\u??.????+
00000010 : 3b 88 1d a5 b3 00 3b 35 - 68 37 c2 de 5d d9 43 ae : ;?.??.;5h7??]?C?
00000020 : 3d b4 7b fc 5c f9 67 45 - 7c 10 f2 22 68 fd 4e 0c : =?{?\?gE|.?"h?N.
00000030 : 42 7b ed bd 24 1c 9e 7d - 13 bc 0b ea 1b e7 e0 08 : B{??$.?}.?.?.??.
00000040 : d7 58 8e 13 14 15 7a 2a - aa 54 d9 09 b7 ce 80 5c : ?X?...z*?T?.???\
00000050 : c5 ec 2f b0 93 b3 c3 fb - 82 c4 18 32 1b 48 7b 2b : ??/???????.2.H{+
00000060 : 28 ff 17 16 08 e3 34 b4 - c0 4c 07 27 6f 1e 2a 11 : (?...?4??L.'o.*.
00000070 : af 8b 0a b8 55 f1 4f e2 - 43 c9 9e e1 5e 5a 33 42 : ??.?U?O?C???^Z3B
'@ -replace '\r?\n', "`n"))

$result = $arraywrapper | Dump-ByteContent -StartAddress 0x00000001 -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly
Assert ($result -join "`n" -ceq (@'
00000000 :    ac 5b 0c ec 23 78 5c - 75 ab 97 14 da c6 f8 f7 : ?[.?#x\u??.????
00000010 : 2b 3b 88 1d a5 b3 00 3b - 35 68 37 c2 de 5d d9 43 : +;?.??.;5h7??]?C
00000020 : ae 3d b4 7b fc 5c f9 67 - 45 7c 10 f2 22 68 fd 4e : ?=?{?\?gE|.?"h?N
00000030 : 0c 42 7b ed bd 24 1c 9e - 7d 13 bc 0b ea 1b e7 e0 : .B{??$.?}.?.?.??
00000040 : 08 d7 58 8e 13 14 15 7a - 2a aa 54 d9 09 b7 ce 80 : .?X?...z*?T?.???
00000050 : 5c c5 ec 2f b0 93 b3 c3 - fb 82 c4 18 32 1b 48 7b : \??/???????.2.H{
00000060 : 2b 28 ff 17 16 08 e3 34 - b4 c0 4c 07 27 6f 1e 2a : +(?...?4??L.'o.*
00000070 : 11 af 8b 0a b8 55 f1 4f - e2 43 c9 9e e1 5e 5a 33 : .??.?U?O?C???^Z3
00000080 : 42                                                : B
'@ -replace '\r?\n', "`n"))

$result = $arraywrapper | Dump-ByteContent -StartAddress 0x0000000f -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly
Assert ($result -join "`n" -ceq (@'
00000000 :                                                ac : ?
00000010 : 5b 0c ec 23 78 5c 75 ab - 97 14 da c6 f8 f7 2b 3b : [.?#x\u??.????+;
00000020 : 88 1d a5 b3 00 3b 35 68 - 37 c2 de 5d d9 43 ae 3d : ?.??.;5h7??]?C?=
00000030 : b4 7b fc 5c f9 67 45 7c - 10 f2 22 68 fd 4e 0c 42 : ?{?\?gE|.?"h?N.B
00000040 : 7b ed bd 24 1c 9e 7d 13 - bc 0b ea 1b e7 e0 08 d7 : {??$.?}.?.?.??.?
00000050 : 58 8e 13 14 15 7a 2a aa - 54 d9 09 b7 ce 80 5c c5 : X?...z*?T?.???\?
00000060 : ec 2f b0 93 b3 c3 fb 82 - c4 18 32 1b 48 7b 2b 28 : ?/???????.2.H{+(
00000070 : ff 17 16 08 e3 34 b4 c0 - 4c 07 27 6f 1e 2a 11 af : ?...?4??L.'o.*.?
00000080 : 8b 0a b8 55 f1 4f e2 43 - c9 9e e1 5e 5a 33 42    : ?.?U?O?C???^Z3B
'@ -replace '\r?\n', "`n"))

$result = $arraywrapper | Dump-ByteContent -StartAddress 0x00000010 -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly
Assert ($result -join "`n" -ceq (@'
00000010 : ac 5b 0c ec 23 78 5c 75 - ab 97 14 da c6 f8 f7 2b : ?[.?#x\u??.????+
00000020 : 3b 88 1d a5 b3 00 3b 35 - 68 37 c2 de 5d d9 43 ae : ;?.??.;5h7??]?C?
00000030 : 3d b4 7b fc 5c f9 67 45 - 7c 10 f2 22 68 fd 4e 0c : =?{?\?gE|.?"h?N.
00000040 : 42 7b ed bd 24 1c 9e 7d - 13 bc 0b ea 1b e7 e0 08 : B{??$.?}.?.?.??.
00000050 : d7 58 8e 13 14 15 7a 2a - aa 54 d9 09 b7 ce 80 5c : ?X?...z*?T?.???\
00000060 : c5 ec 2f b0 93 b3 c3 fb - 82 c4 18 32 1b 48 7b 2b : ??/???????.2.H{+
00000070 : 28 ff 17 16 08 e3 34 b4 - c0 4c 07 27 6f 1e 2a 11 : (?...?4??L.'o.*.
00000080 : af 8b 0a b8 55 f1 4f e2 - 43 c9 9e e1 5e 5a 33 42 : ??.?U?O?C???^Z3B
'@ -replace '\r?\n', "`n"))

$result = $arraywrapper | Dump-ByteContent -StartAddress 0x00000011 -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly
Assert ($result -join "`n" -ceq (@'
00000010 :    ac 5b 0c ec 23 78 5c - 75 ab 97 14 da c6 f8 f7 : ?[.?#x\u??.????
00000020 : 2b 3b 88 1d a5 b3 00 3b - 35 68 37 c2 de 5d d9 43 : +;?.??.;5h7??]?C
00000030 : ae 3d b4 7b fc 5c f9 67 - 45 7c 10 f2 22 68 fd 4e : ?=?{?\?gE|.?"h?N
00000040 : 0c 42 7b ed bd 24 1c 9e - 7d 13 bc 0b ea 1b e7 e0 : .B{??$.?}.?.?.??
00000050 : 08 d7 58 8e 13 14 15 7a - 2a aa 54 d9 09 b7 ce 80 : .?X?...z*?T?.???
00000060 : 5c c5 ec 2f b0 93 b3 c3 - fb 82 c4 18 32 1b 48 7b : \??/???????.2.H{
00000070 : 2b 28 ff 17 16 08 e3 34 - b4 c0 4c 07 27 6f 1e 2a : +(?...?4??L.'o.*
00000080 : 11 af 8b 0a b8 55 f1 4f - e2 43 c9 9e e1 5e 5a 33 : .??.?U?O?C???^Z3
00000090 : 42                                                : B
'@ -replace '\r?\n', "`n"))

$result = $arraywrapper | Dump-ByteContent -BytesPerLine 24 -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly
Assert ($result -join "`n" -ceq (@'
00000000 : ac 5b 0c ec 23 78 5c 75 - ab 97 14 da c6 f8 f7 2b - 3b 88 1d a5 b3 00 3b 35 : ?[.?#x\u??.????+;?.??.;5
00000018 : 68 37 c2 de 5d d9 43 ae - 3d b4 7b fc 5c f9 67 45 - 7c 10 f2 22 68 fd 4e 0c : h7??]?C?=?{?\?gE|.?"h?N.
00000030 : 42 7b ed bd 24 1c 9e 7d - 13 bc 0b ea 1b e7 e0 08 - d7 58 8e 13 14 15 7a 2a : B{??$.?}.?.?.??.?X?...z*
00000048 : aa 54 d9 09 b7 ce 80 5c - c5 ec 2f b0 93 b3 c3 fb - 82 c4 18 32 1b 48 7b 2b : ?T?.???\??/???????.2.H{+
00000060 : 28 ff 17 16 08 e3 34 b4 - c0 4c 07 27 6f 1e 2a 11 - af 8b 0a b8 55 f1 4f e2 : (?...?4??L.'o.*.??.?U?O?
00000078 : 43 c9 9e e1 5e 5a 33 42                                                     : C???^Z3B
'@ -replace '\r?\n', "`n"))

$result = $arraywrapper | Dump-ByteContent -StartAddress 0x00000017 -BytesPerLine 24 -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly
Assert ($result -join "`n" -ceq (@'
00000000 :                                                                          ac : ?
00000018 : 5b 0c ec 23 78 5c 75 ab - 97 14 da c6 f8 f7 2b 3b - 88 1d a5 b3 00 3b 35 68 : [.?#x\u??.????+;?.??.;5h
00000030 : 37 c2 de 5d d9 43 ae 3d - b4 7b fc 5c f9 67 45 7c - 10 f2 22 68 fd 4e 0c 42 : 7??]?C?=?{?\?gE|.?"h?N.B
00000048 : 7b ed bd 24 1c 9e 7d 13 - bc 0b ea 1b e7 e0 08 d7 - 58 8e 13 14 15 7a 2a aa : {??$.?}.?.?.??.?X?...z*?
00000060 : 54 d9 09 b7 ce 80 5c c5 - ec 2f b0 93 b3 c3 fb 82 - c4 18 32 1b 48 7b 2b 28 : T?.???\??/???????.2.H{+(
00000078 : ff 17 16 08 e3 34 b4 c0 - 4c 07 27 6f 1e 2a 11 af - 8b 0a b8 55 f1 4f e2 43 : ?...?4??L.'o.*.??.?U?O?C
00000090 : c9 9e e1 5e 5a 33 42                                                        : ???^Z3B
'@ -replace '\r?\n', "`n"))

$result = $arraywrapper | Dump-ByteContent -StartAddress 0x00000018 -BytesPerLine 24 -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly
Assert ($result -join "`n" -ceq (@'
00000018 : ac 5b 0c ec 23 78 5c 75 - ab 97 14 da c6 f8 f7 2b - 3b 88 1d a5 b3 00 3b 35 : ?[.?#x\u??.????+;?.??.;5
00000030 : 68 37 c2 de 5d d9 43 ae - 3d b4 7b fc 5c f9 67 45 - 7c 10 f2 22 68 fd 4e 0c : h7??]?C?=?{?\?gE|.?"h?N.
00000048 : 42 7b ed bd 24 1c 9e 7d - 13 bc 0b ea 1b e7 e0 08 - d7 58 8e 13 14 15 7a 2a : B{??$.?}.?.?.??.?X?...z*
00000060 : aa 54 d9 09 b7 ce 80 5c - c5 ec 2f b0 93 b3 c3 fb - 82 c4 18 32 1b 48 7b 2b : ?T?.???\??/???????.2.H{+
00000078 : 28 ff 17 16 08 e3 34 b4 - c0 4c 07 27 6f 1e 2a 11 - af 8b 0a b8 55 f1 4f e2 : (?...?4??L.'o.*.??.?U?O?
00000090 : 43 c9 9e e1 5e 5a 33 42                                                     : C???^Z3B
'@ -replace '\r?\n', "`n"))

$result = $arraywrapper | Dump-ByteContent -StartAddress 0x00000019 -BytesPerLine 24 -Encoding ([System.Text.Encoding]::ASCII) -PrintableOnly
Assert ($result -join "`n" -ceq (@'
00000018 :    ac 5b 0c ec 23 78 5c - 75 ab 97 14 da c6 f8 f7 - 2b 3b 88 1d a5 b3 00 3b : ?[.?#x\u??.????+;?.??.;
00000030 : 35 68 37 c2 de 5d d9 43 - ae 3d b4 7b fc 5c f9 67 - 45 7c 10 f2 22 68 fd 4e : 5h7??]?C?=?{?\?gE|.?"h?N
00000048 : 0c 42 7b ed bd 24 1c 9e - 7d 13 bc 0b ea 1b e7 e0 - 08 d7 58 8e 13 14 15 7a : .B{??$.?}.?.?.??.?X?...z
00000060 : 2a aa 54 d9 09 b7 ce 80 - 5c c5 ec 2f b0 93 b3 c3 - fb 82 c4 18 32 1b 48 7b : *?T?.???\??/???????.2.H{
00000078 : 2b 28 ff 17 16 08 e3 34 - b4 c0 4c 07 27 6f 1e 2a - 11 af 8b 0a b8 55 f1 4f : +(?...?4??L.'o.*.??.?U?O
00000090 : e2 43 c9 9e e1 5e 5a 33 - 42                                                : ?C???^Z3B
'@ -replace '\r?\n', "`n"))
}
