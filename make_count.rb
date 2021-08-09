# 感染者数（判明日ベース）

require "json"
require "date"
require "time"

def file_read(path)
  File.open(path, "r:utf-8") { |f| f.read }
end

# [
#   ["延岡市・西臼杵郡圏域", "延岡市"],
#   ["延岡市・西臼杵郡圏域", "高千穂町"],
#   ...
#   ["日向市・東臼杵郡圏域", "日向市"],
#   ["日向市・東臼杵郡圏域", "門川町"],
#   ...
#   ["日南市・串間市圏域", "圏域合計"]
# ]
# 最初の2列は除外
def make_col_meta(rows)
  # 圏域
  area_cols = rows[1][2..-1]
  # 市町村
  city_cols = rows[2][2..-1]

  num_cols = area_cols.size
  area = nil
  col_meta = []

  (0...num_cols).each do |ci|
    if area_cols[ci] != ""
      area = area_cols[ci]
    end
    city = city_cols[ci]
    next if city == "" # 最後の列は不要なので除外

    col_meta << [area, city]
  end

  col_meta
end

# --------------------------------

rows = []
file_read("tmp/data.txt").each_line do |line|
  # TODO ゴミデータの行を除外
  next if /^CE>/ =~ line

  rows << JSON.parse(line)
end

date_origin = Date.new(1900, 1, 1) - 2

col_meta = make_col_meta(rows)

data = []
rows[3..-1].each do |cols|
  date = date_origin + cols[0].to_i

  details = []
  col_meta.each_with_index do |area_city, i|
    next if area_city[1] == "圏域合計"

    ci = 2 + i
    details << {
      "市町村" => area_city[1],
      "小計" => cols[ci].to_i
    }
  end

  data << {
    "日付" => date.to_s,
    "市町村集計" => details
  }
end

puts(
  JSON.pretty_generate(
    {
      "データ" => data,
      "更新日時" => Time.now.iso8601
    }
  )
)
