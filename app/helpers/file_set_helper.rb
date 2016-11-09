module FileSetHelper
  def loris_url_for(file_set_id)
    file_set = FileSet.find(file_set_id)
    lowres = cannot?(:update, file_set) && file_set.under_copyright? ? 'lowres' : nil
    ENV['LORIS_SERVER_URI'] + file_set.loris_id(lowres)
  end
end
