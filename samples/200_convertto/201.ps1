
$hexstring = ConvertFrom-ByteContent -InputObject $samplebytelist[0]
Assert ($hexstring -ceq '051d2c3b4e5868798e9fa0b3ced8eef00f112f3a4c5665718c99a6b2c4dee5fe')

$hexstring = ConvertFrom-ByteContent -InputObject $samplebytelist[0] -Capital
Assert ($hexstring -ceq '051D2C3B4E5868798E9FA0B3CED8EEF00F112F3A4C5665718C99A6B2C4DEE5FE')

$arraywrapper.Clear()
(0..3) |% {$arraywrapper.Add($samplebytelist[$_])}
$hexstring = $arraywrapper | ConvertFrom-ByteContent
Assert ($hexstring -ceq '051d2c3b4e5868798e9fa0b3ced8eef00f112f3a4c5665718c99a6b2c4dee5fe08132939425b6e7b8b97a2b7cadfe5f3051b243644586c7b8f9ea3bcc3dbe7fa0b1224364f566f748b9babb0c4d3e8fc091d273f475f6173889fa2b7c4d5eef405112a35455c6e7d8592a1b2c9dbeafe07162c3f485e62748896a4bac4d4e3fe')

$arraywrapper.Clear()
(0..3) |% {$arraywrapper.Add($samplebytelist[$_])}
$hexstring = $arraywrapper | ConvertFrom-ByteContent -Capital
Assert ($hexstring -ceq '051D2C3B4E5868798E9FA0B3CED8EEF00F112F3A4C5665718C99A6B2C4DEE5FE08132939425B6E7B8B97A2B7CADFE5F3051B243644586C7B8F9EA3BCC3DBE7FA0B1224364F566F748B9BABB0C4D3E8FC091D273F475F6173889FA2B7C4D5EEF405112A35455C6E7D8592A1B2C9DBEAFE07162C3F485E62748896A4BAC4D4E3FE')


# 配列平滑化により 1 バイトずつに分割される
$hexstring = $samplebytelist[0] | ConvertFrom-ByteContent
Assert ($hexstring -ceq '051d2c3b4e5868798e9fa0b3ced8eef00f112f3a4c5665718c99a6b2c4dee5fe')

$hexstring = $samplebytelist[0] | ConvertFrom-ByteContent -Capital
Assert ($hexstring -ceq '051D2C3B4E5868798E9FA0B3CED8EEF00F112F3A4C5665718C99A6B2C4DEE5FE')

$hexstring = (0..3) |% {$samplebytelist[$_]} | ConvertFrom-ByteContent
Assert ($hexstring -ceq '051d2c3b4e5868798e9fa0b3ced8eef00f112f3a4c5665718c99a6b2c4dee5fe08132939425b6e7b8b97a2b7cadfe5f3051b243644586c7b8f9ea3bcc3dbe7fa0b1224364f566f748b9babb0c4d3e8fc091d273f475f6173889fa2b7c4d5eef405112a35455c6e7d8592a1b2c9dbeafe07162c3f485e62748896a4bac4d4e3fe')

$hexstring = (0..3) |% {$samplebytelist[$_]} | ConvertFrom-ByteContent -Capital
Assert ($hexstring -ceq '051D2C3B4E5868798E9FA0B3CED8EEF00F112F3A4C5665718C99A6B2C4DEE5FE08132939425B6E7B8B97A2B7CADFE5F3051B243644586C7B8F9EA3BCC3DBE7FA0B1224364F566F748B9BABB0C4D3E8FC091D273F475F6173889FA2B7C4D5EEF405112A35455C6E7D8592A1B2C9DBEAFE07162C3F485E62748896A4BAC4D4E3FE')
