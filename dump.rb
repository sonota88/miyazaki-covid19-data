require "json"

require_relative "libo_calc"

def main(file, sheet_name)
  Calc.open(file) do |doc|
    sheet = doc.get_sheet_by_name(sheet_name)

    rows =
      (0..(sheet.used_row_index_max)).map do |ri|
        (0..(sheet.used_column_index_max)).map do |ci|
          sheet.get(ci, ri)
        end
      end

    rows.each do |cols|
      puts JSON.generate(cols)
    end
  end
end

main(
  ARGV[0], # fods ファイル名
  ARGV[1]  # シート名
)
