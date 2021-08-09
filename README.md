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
