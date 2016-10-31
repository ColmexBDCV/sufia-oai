module CurationConcernsHelper
  include ::BlacklightHelper
  include CurationConcerns::MainAppHelpers

  def format_characterization_values(term, values)
    return [] unless values.respond_to? :map

    case term
    when :file_size
      values.map { |v| number_to_human_size(v) }
    when :width, :height
      values.map { |v| "#{v} px" }
    else
      values
    end
  end
end
