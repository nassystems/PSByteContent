$arraywrapper.Clear()
$arraywrapper.Add($samplebytelist[1])

& {
# 3 バイトごとに "-" を打つ。
$hexstring = $arraywrapper | ConvertFrom-ByteContent -SeparatorHash @{3='-'}
Assert ($hexstring -ceq '081329-39425b-6e7b8b-97a2b7-cadfe5-f3051b-243644-586c7b-8f9ea3-bcc3db-e7fa')
}
& {
# 区切り文字は大文字化されない。
$hexstring = $arraywrapper | ConvertFrom-ByteContent -SeparatorHash @{3='x'} -Capital
Assert ($hexstring -ceq '081329x39425Bx6E7B8Bx97A2B7xCADFE5xF3051Bx243644x586C7Bx8F9EA3xBCC3DBxE7FA')
}
& {
# 3 バイトごとに "-" を、
# 16 バイトごとに "__" を、
# 48 バイトごとに "**" を打つ。
# (32 バイトしか与えていないので "**" は表れない)
$hexstring = $arraywrapper | ConvertFrom-ByteContent -SeparatorHash @{3='-'; 16='__'; 48='**'}
Assert ($hexstring -ceq '081329-39425b-6e7b8b-97a2b7-cadfe5-f3__051b-243644-586c7b-8f9ea3-bcc3db-e7fa')
}
& {
# 4 バイトごとに "-" を、
# 8 バイトごとに "_" を打つ。(長周期の区切り文字はより短周期の区切り文字を上書きする。)
$hexstring = $arraywrapper | ConvertFrom-ByteContent -SeparatorHash @{4='-'; 16='_'}
Assert ($hexstring -ceq '08132939-425b6e7b-8b97a2b7-cadfe5f3_051b2436-44586c7b-8f9ea3bc-c3dbe7fa')
}
& {
# 1 バイトごとにスペースを打つ。
$hexstring = $arraywrapper | ConvertFrom-ByteContent -SeparatorHash @{1=' '}
Assert ($hexstring -ceq '08 13 29 39 42 5b 6e 7b 8b 97 a2 b7 ca df e5 f3 05 1b 24 36 44 58 6c 7b 8f 9e a3 bc c3 db e7 fa')
}
& {
# 4 バイトごとに "-" を打つ。
# 8 バイトごとに文字列を分割する。
$hexstring = $arraywrapper | ConvertFrom-ByteContent -SeparatorHash @{4='-'; 8=$null}
Assert ($hexstring.GetType() -eq [object[]])
Assert ($hexstring.Length -eq 4)
Assert ($hexstring[0] -ceq '08132939-425b6e7b')
Assert ($hexstring[1] -ceq '8b97a2b7-cadfe5f3')
Assert ($hexstring[2] -ceq '051b2436-44586c7b')
Assert ($hexstring[3] -ceq '8f9ea3bc-c3dbe7fa')
}

# 配列平滑化により 1 バイトずつに分割される
& {
$hexstring = $samplebytelist[1] | ConvertFrom-ByteContent -SeparatorHash @{3='-'}
Assert ($hexstring -ceq '081329-39425b-6e7b8b-97a2b7-cadfe5-f3051b-243644-586c7b-8f9ea3-bcc3db-e7fa')
}
& {
$hexstring = $samplebytelist[1] | ConvertFrom-ByteContent -SeparatorHash @{3='x'} -Capital
Assert ($hexstring -ceq '081329x39425Bx6E7B8Bx97A2B7xCADFE5xF3051Bx243644x586C7Bx8F9EA3xBCC3DBxE7FA')
}
& {
$hexstring = $samplebytelist[1] | ConvertFrom-ByteContent -SeparatorHash @{3='-'; 16='__'; 48='**'}
Assert ($hexstring -ceq '081329-39425b-6e7b8b-97a2b7-cadfe5-f3__051b-243644-586c7b-8f9ea3-bcc3db-e7fa')
}
& {
$hexstring = $samplebytelist[1] | ConvertFrom-ByteContent -SeparatorHash @{4='-'; 16='_'}
Assert ($hexstring -ceq '08132939-425b6e7b-8b97a2b7-cadfe5f3_051b2436-44586c7b-8f9ea3bc-c3dbe7fa')
}
& {
$hexstring = $samplebytelist[1] | ConvertFrom-ByteContent -SeparatorHash @{1=' '}
Assert ($hexstring -ceq '08 13 29 39 42 5b 6e 7b 8b 97 a2 b7 ca df e5 f3 05 1b 24 36 44 58 6c 7b 8f 9e a3 bc c3 db e7 fa')
}
& {
$hexstring = $samplebytelist[1] | ConvertFrom-ByteContent -SeparatorHash @{4='-'; 8=$null}
Assert ($hexstring.GetType() -eq [object[]])
Assert ($hexstring.Length -eq 4)
Assert ($hexstring[0] -ceq '08132939-425b6e7b')
Assert ($hexstring[1] -ceq '8b97a2b7-cadfe5f3')
Assert ($hexstring[2] -ceq '051b2436-44586c7b')
Assert ($hexstring[3] -ceq '8f9ea3bc-c3dbe7fa')
}
