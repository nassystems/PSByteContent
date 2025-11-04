
# テストと検証用の資材データ

$arraywrapper = New-Object System.Collections.Generic.List[byte[]]

$samplebytes = New-Object System.Collections.Generic.List[Byte]
$samplebytelist = New-Object System.Collections.Generic.List[Byte[]]
$sampleb64list  = New-Object System.Collections.Generic.List[String]

@'
BR0sO05YaHmOn6Czztju8A8RLzpMVmVxjJmmssTe5f4=
CBMpOUJbbnuLl6K3yt/l8wUbJDZEWGx7j56jvMPb5/o=
CxIkNk9Wb3SLm6uwxNPo/AkdJz9HX2FziJ+it8TV7vQ=
BREqNUVcbn2FkqGyydvq/gcWLD9IXmJ0iJakusTU4/4=
gtivZ/81t6CeweiAGGlL6YL1uolJaGgDdoXF7hZZsPg=
plBqfSDx/mUrhphoIRjtFJOeI9HR/6sSvZrraZo64Kk=
rFsM7CN4XHWrlxTaxvj3KzuIHaWzADs1aDfC3l3ZQ64=
PbR7/Fz5Z0V8EPIiaP1ODEJ77b0kHJ59E7wL6hvn4Ag=
11iOExQVeiqqVNkJt86AXMXsL7CTs8P7gsQYMhtIeys=
KP8XFgjjNLTATAcnbx4qEa+LCrhV8U/iQ8me4V5aM0I=
L94KSGNNYABNdG0Ef7MfY4BKys1+NNiANhaEhybknvQ=
qxLGnDQU+0e6+XtnVxBPcT9gd+p5MVQtp7WMwaVmmaM=
WQM6Zjh+jcXDyMM45aJbkCQ4Q3qJPxpKUz81TWiUNEU=
FpqvLDWBiiz/UYGTLOnE2xPrp4xHFxUVBdjRmAzekHU=
ia8PL0wbItyBrxCXOZLHk6MFR9jSWWxc5ZrkfWxUNF4=
0u3J82UPGmNtWaN6pmea9XvsfMO5rO1W0ARfoVWLyBk=
2fwIMpG2UMpTnjlZU4NxmqW7qt8kqla8eutcgz/ZVzw=
Y6Vq715KZfMF4FGlsX4SQhuwjteB7QAQpbvv/+m2MkI=
IexlJQqze0wyKowKwWdLEuAyeW/9NdfRYIFihTV3A3w=
t+t3J6Iu5FDsBSxwqTUCgqKHitOe0mTzCQk9eECgczA=
zx2sHRbH4/4c1dEjLQeme53ZD4SZ5hR2WUSFdLpbl4w=
QiucTVk9kIzcWT+E4hz+LBvAJo12qkRmj0ejQNak4WE=
mBn9srjxzD9ESj7ulCqLWnfKBrYL6fns80DVFWqwpvw=
ZW9f13++3JvM+PM264jR3eZrP6LG5ivDjlc3DFWh5K8=
vs34G/gRP9SC9sjN9kM5JHVwyFSE2GcpkvYWKTMBHRI=
J6XvbMCbeuFtS5Xwqsh8YLgEO2W0silkY5r0At98xjw=
OEgQZuq51HSK1Jem+USH+tv6YIULz22Ciu7mKDfbTQ8=
vbLPzngfJnfyTdL93i2PJ3yzFJ//nOP+sgLeJocAWxg=
tlEJvCP57ISi7aZXbLYfFcVn8gVyyjgWb3KPhkIAGiY=
RUf6hN9psM1GqW/R98Y3p5lRrQtveFoVjlfFuApUk3o=
t1IfJGKwIHIr1G+o9KD9p3nKYLAkB8jsjyO6x4jryQ0=
Awk7L/eSQ4EcQ+hxkBl0VQT2CR+xa2w1tDXMaO0PdtA=
'@ -split '\r?\n' |% {
    $partbytes = [convert]::FromBase64String($_)
    $samplebytes.AddRange($partbytes)
    $samplebytelist.Add($partbytes)
    $sampleb64list.Add($_)
}

$samplebytes = $samplebytes.ToArray()


$samplehashlist = New-Object System.Collections.Generic.List[Byte[]]

@'
ojalCWXX5lClVazIpSG+B+ywEDQ=
P9D9WZqjpUjcgbjlsup1MBiFm6g=
9gPB+iunBinw8mHSYSU4Y7bhskc=
dWt5RQA0zjyHO7ImtYyp1Qp8cJo=
qD7NJnim45PzX5/ZKKVQpA2SJGE=
q/45wD/Pg+Yom3TB6/I3nM/wo7Y=
mBzlO5h/IJodeoKBhbRnnXLEVOc=
FHsG7082ikBe69/A6dplS6c3jeY=
hRzphxpjAZhkFR5e9GI3zOnjvjg=
rGUckBAs5fawrDOouHaf42OfuuI=
ZHvfO7nlCOarEsiJq/oaNnSVeok=
I6norZrEE94LQxJDRNXx7gwBJmI=
t/LtuVli0lzgJx6itUaz2QPAS5c=
t7ssIknhU4CHooNioo4HsEq+pMo=
RgUgooyNVcEo8eh78TcEAmMUvQ4=
rduE9Qjv+1ff+hhoMxvT6HDnuNU=
PMXOeME9eOZGlGcXqK7I7eve1jQ=
yuSCx8/B2zzSFD3v6Jlf3MxdIe8=
PXNF9ZkUDYu5w9XYvL3uDIhzlnQ=
kqvyaHkq2TeGrx1oKlJGS74I9TE=
laUE+gNB5DSylUnj2kTpyrk3TaM=
erL5GoR2qLOHkbtaxqrmkDN3Iv4=
APwAL0Tcu2VvQoi4aOgItDZhGtI=
JLuIzA1m5FFIVX3L+NLWQDN1yJI=
OVZovVb9iBXDamjz5RoxJSAobU4=
Fb7H3g+U0bovz82gYaUt0xVYasE=
Scl/VAO7EfYXXghyeTapeOlJKMc=
16suZHLctZg/e6x8QIe6C/JigvA=
AaDmEzAWrxBRCQnLD18fQf+vVGo=
q1fiRpAv3oL7VtIGVAx97t9R5yI=
AXidoZ+opRPLjalzuzx2ksMcfw8=
VlDt/5KFqCcI54VE8EcFsi23VNc=
'@ -split '\r?\n' |% {
    $samplehashlist.Add([System.Convert]::FromBase64String($_))
}
