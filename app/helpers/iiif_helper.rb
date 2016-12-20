module IiifHelper
  def iiif_url_for(obj, lowres = false)
    lowres = if lowres
               'lowres'
             else
               cannot?(:update, obj) && obj.under_copyright? ? 'lowres' : nil
             end

    Rails.configuration.x.iiif.base_url + obj.iiif_id(lowres)
  end

  def iiif_derivative_url(document, opts = {})
    opts = { region: 'full', size: '!800,800', rotation: 0, quality: 'default', format: 'jpg' }.merge(opts)
    "#{iiif_url_for(document, true)}/#{opts[:region]}/#{opts[:size]}/#{opts[:rotation]}/#{opts[:quality]}.#{opts[:format]}"
  end
end
