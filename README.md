do this to generate dictionary

```
curl -LO https://raw.githubusercontent.com/skk-dev/dict/master/SKK-JISYO.L
iconv -f EUC-JP -t UTF-8 SKK-JISYO.L > SKK-JISYO.L.utf8
```
