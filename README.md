```
Docker イメージのビルド

docker build -t miyazaki-covid19-data:0.0.1 .

実行

docker run --rm -it \
  -v "$(pwd):/root/work" \
  miyazaki-covid19-data:0.0.1

データを生成

./run.sh
```


# 資料

データで見る宮崎県の感染状況：宮崎県新型コロナウイルス感染症対策特設サイト  
http://www.pref.miyazaki.lg.jp/covid-19/kenmin/20200804143434.html
