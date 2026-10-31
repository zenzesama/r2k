Lua 5.5 is vendored in vendor/lua (MIT, lua.org)

do this to generate dictionary

```
curl -LO https://raw.githubusercontent.com/skk-dev/dict/master/SKK-JISYO.L
iconv -f EUC-JP -t UTF-8 SKK-JISYO.L > SKK-JISYO.L.utf8
```

then this to sort it (warning: 16050 is hardcoded because that is where comments end, may not be same on your end, it should be buy it may not. Please check and edit accordingly!)
```
tail -n +16050 SKK-JISYO.L.utf8 | LC_ALL=C sort -t' ' -k1,1 > okuri-nasi.txt
```
