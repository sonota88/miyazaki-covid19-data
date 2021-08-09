#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

IMAGE_FULL=miyazaki-covid19-data:0.0.1
TEMP_XLSX=tmp/data.xlsx
TEMP_TEXT=tmp/data.txt

# データで見る宮崎県の感染状況（令和2年7月22日～令和3年7月31日）：宮崎県新型コロナウイルス感染症対策特設サイト
# https://www.pref.miyazaki.lg.jp/fukushihoken/covid-19/kenmin/20200923170835.html
XLSX_URL="https://www.pref.miyazaki.lg.jp/fukushihoken/covid-19/kenmin/documents/54698_20210802120012-1.xlsx"

docker_run() {
  docker run --rm -it -v "$(pwd):/root/work" $IMAGE_FULL \
    "$@"
}

docker_jruby() {
  docker_run bash jruby.sh "$@"
}

_ruby() {
  # docker_jruby "$@"
  ruby "$@"
}

# xlsx ファイルを取得
wget -O- --quiet $XLSX_URL \
  > $TEMP_XLSX

# テキストデータに変換
docker_jruby dump.rb $TEMP_XLSX "データエリア" \
  > $TEMP_TEXT

# ここから先は JRuby ではなく普通の Ruby でもよい

# JSON に整形
_ruby make_count.rb $TEMP_TEXT \
  > data/count.json

# 県単位の集計
_ruby make_count_sum.rb data/count.json \
  > data/count_sum.json
