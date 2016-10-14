module ImportsHelper
  def import_type_list
    [
      ["Generic", "generic"]
    ]
  end

  def status_icon_class_for(import)
    case import.status
    when 'not_ready'
      'glyphicon-question-sign'
    when 'ready'
      'glyphicon-thumbs-up'
    when 'in_progress'
      'glyphicon-time'
    when 'complete'
      'glyphicon-ok'
    when 'reverting'
      'glyphicon-backward'
    when 'final'
      'glyphicon-lock'
    else
      'glyphicon-warning-sign'
    end
  end

  def last_run_for(import)
    import.last_run_at ? import.last_run_at.strftime("%-m/%-d/%Y %l:%M%P") : content_tag(:em, "Never")
  end

  def import_field_select_class_for(field)
    ['image_filename', 'handle'].include?(field.object.key) ? 'chosen-select-max-1' : 'chosen-select'
  end

  def import_field_form_class_for(field)
    Import::REQUIRED_FIELDS.include?(field.object.key) ? 'required' : ''
  end
end
