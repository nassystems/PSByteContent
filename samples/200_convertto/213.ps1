$arraywrapper.Clear()
(0..3) |% {
    $arraywrapper.Add($samplebytelist[$_])
}

# 3 バイトごとに "-" を打つ。
$hexstring = $arraywrapper | ConvertFrom-ByteContent -SeparatorHash @{3='-'}
Assert ($hexstring -ceq '051d2c-3b4e58-68798e-9fa0b3-ced8ee-f00f11-2f3a4c-566571-8c99a6-b2c4de-e5fe08-132939-425b6e-7b8b97-a2b7ca-dfe5f3-051b24-364458-6c7b8f-9ea3bc-c3dbe7-fa0b12-24364f-566f74-8b9bab-b0c4d3-e8fc09-1d273f-475f61-73889f-a2b7c4-d5eef4-05112a-35455c-6e7d85-92a1b2-c9dbea-fe0716-2c3f48-5e6274-8896a4-bac4d4-e3fe')

# 区切り文字は大文字化されない。
$hexstring = $arraywrapper | ConvertFrom-ByteContent -SeparatorHash @{3='x'} -Capital
Assert ($hexstring -ceq '051D2Cx3B4E58x68798Ex9FA0B3xCED8EExF00F11x2F3A4Cx566571x8C99A6xB2C4DExE5FE08x132939x425B6Ex7B8B97xA2B7CAxDFE5F3x051B24x364458x6C7B8Fx9EA3BCxC3DBE7xFA0B12x24364Fx566F74x8B9BABxB0C4D3xE8FC09x1D273Fx475F61x73889FxA2B7C4xD5EEF4x05112Ax35455Cx6E7D85x92A1B2xC9DBEAxFE0716x2C3F48x5E6274x8896A4xBAC4D4xE3FE')

# 3 バイトごとに "-" を、
# 16 バイトごとに "__" を、
# 48 バイトごとに "**" を打つ。(長周期の区切り文字はより短周期の区切り文字を上書きする。)
$hexstring = $arraywrapper | ConvertFrom-ByteContent -SeparatorHash @{3='-'; 16='__'; 48='**'}
Assert ($hexstring -ceq '051d2c-3b4e58-68798e-9fa0b3-ced8ee-f0__0f11-2f3a4c-566571-8c99a6-b2c4de-e5fe__08-132939-425b6e-7b8b97-a2b7ca-dfe5f3**051b24-364458-6c7b8f-9ea3bc-c3dbe7-fa__0b12-24364f-566f74-8b9bab-b0c4d3-e8fc__09-1d273f-475f61-73889f-a2b7c4-d5eef4**05112a-35455c-6e7d85-92a1b2-c9dbea-fe__0716-2c3f48-5e6274-8896a4-bac4d4-e3fe')

# 1 バイトごとにスペースを打つ。
$hexstring = $arraywrapper | ConvertFrom-ByteContent -SeparatorHash @{1=' '}
Assert ($hexstring -ceq '05 1d 2c 3b 4e 58 68 79 8e 9f a0 b3 ce d8 ee f0 0f 11 2f 3a 4c 56 65 71 8c 99 a6 b2 c4 de e5 fe 08 13 29 39 42 5b 6e 7b 8b 97 a2 b7 ca df e5 f3 05 1b 24 36 44 58 6c 7b 8f 9e a3 bc c3 db e7 fa 0b 12 24 36 4f 56 6f 74 8b 9b ab b0 c4 d3 e8 fc 09 1d 27 3f 47 5f 61 73 88 9f a2 b7 c4 d5 ee f4 05 11 2a 35 45 5c 6e 7d 85 92 a1 b2 c9 db ea fe 07 16 2c 3f 48 5e 62 74 88 96 a4 ba c4 d4 e3 fe')


# 配列平滑化により 1 バイトずつに分割される
$hexstring = (0..3) |% {$samplebytelist[$_]} | ConvertFrom-ByteContent -SeparatorHash @{3='-'}
Assert ($hexstring -ceq '051d2c-3b4e58-68798e-9fa0b3-ced8ee-f00f11-2f3a4c-566571-8c99a6-b2c4de-e5fe08-132939-425b6e-7b8b97-a2b7ca-dfe5f3-051b24-364458-6c7b8f-9ea3bc-c3dbe7-fa0b12-24364f-566f74-8b9bab-b0c4d3-e8fc09-1d273f-475f61-73889f-a2b7c4-d5eef4-05112a-35455c-6e7d85-92a1b2-c9dbea-fe0716-2c3f48-5e6274-8896a4-bac4d4-e3fe')

$hexstring = (0..3) |% {$samplebytelist[$_]} | ConvertFrom-ByteContent -SeparatorHash @{3='x'} -Capital
Assert ($hexstring -ceq '051D2Cx3B4E58x68798Ex9FA0B3xCED8EExF00F11x2F3A4Cx566571x8C99A6xB2C4DExE5FE08x132939x425B6Ex7B8B97xA2B7CAxDFE5F3x051B24x364458x6C7B8Fx9EA3BCxC3DBE7xFA0B12x24364Fx566F74x8B9BABxB0C4D3xE8FC09x1D273Fx475F61x73889FxA2B7C4xD5EEF4x05112Ax35455Cx6E7D85x92A1B2xC9DBEAxFE0716x2C3F48x5E6274x8896A4xBAC4D4xE3FE')

$hexstring = (0..3) |% {$samplebytelist[$_]} | ConvertFrom-ByteContent -SeparatorHash @{3='-'; 16='__'; 48='**'}
Assert ($hexstring -ceq '051d2c-3b4e58-68798e-9fa0b3-ced8ee-f0__0f11-2f3a4c-566571-8c99a6-b2c4de-e5fe__08-132939-425b6e-7b8b97-a2b7ca-dfe5f3**051b24-364458-6c7b8f-9ea3bc-c3dbe7-fa__0b12-24364f-566f74-8b9bab-b0c4d3-e8fc__09-1d273f-475f61-73889f-a2b7c4-d5eef4**05112a-35455c-6e7d85-92a1b2-c9dbea-fe__0716-2c3f48-5e6274-8896a4-bac4d4-e3fe')

$hexstring = (0..3) |% {$samplebytelist[$_]} | ConvertFrom-ByteContent -SeparatorHash @{1=' '}
Assert ($hexstring -ceq '05 1d 2c 3b 4e 58 68 79 8e 9f a0 b3 ce d8 ee f0 0f 11 2f 3a 4c 56 65 71 8c 99 a6 b2 c4 de e5 fe 08 13 29 39 42 5b 6e 7b 8b 97 a2 b7 ca df e5 f3 05 1b 24 36 44 58 6c 7b 8f 9e a3 bc c3 db e7 fa 0b 12 24 36 4f 56 6f 74 8b 9b ab b0 c4 d3 e8 fc 09 1d 27 3f 47 5f 61 73 88 9f a2 b7 c4 d5 ee f4 05 11 2a 35 45 5c 6e 7d 85 92 a1 b2 c9 db ea fe 07 16 2c 3f 48 5e 62 74 88 96 a4 ba c4 d4 e3 fe')
