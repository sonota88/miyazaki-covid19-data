require "json"

def file_read(path)
  File.open(path, "r:utf-8") { |f| f.read }
end

# --------------------------------

infile = ARGV[0]

data = JSON.parse(file_read(infile))

summary =
  data["データ"].map { |date_data|
    sum =
      date_data["市町村集計"]
        .map { |city_data| city_data["小計"] }
        .sum
    {
      "日付" => date_data["日付"],
      "小計" => sum
    }
  }

puts JSON.pretty_generate(summary)
