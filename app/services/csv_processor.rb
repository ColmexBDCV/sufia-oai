class CSVProcessor
  attr_accessor :files, :csv_row_array

  def initialize(pid, filename)
    @files = []
    @csv_row_array = []
    @pid = pid
    @filename = filename
    @built_array = false
  end

  def complex_object?
    @pid && !@filename
  end

  def add_file(file, title)
    @files << { filename: file, title: title }
  end

  def build_csv_array(row)
    return if @built_array
    csv_style_array = []
    row.each { |arr| csv_style_array << arr }
    csv_style_array.each { |arr| @csv_row_array << arr.last }
    @built_array = true
  end

  def child?(cid)
    @pid == cid
  end
end
