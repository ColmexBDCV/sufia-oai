class FindingAidResolver
  PREFIX_IDENTIFIERS = {
    rare: [/SPEC.RARE/],
    tri: [/SPEC.TRI/],
    byrd: [/SPEC.PA.56/, /SPEC.RG.56/, /RG 56/],
    ua: [/RG/],
    cartoon: [/SPEC.CGA/]
  }.freeze

  attr_reader :unit, :identifier

  # ead_id format ex: SPEC.RARE.0137:ref11
  def initialize(ead_id)
    ids = ead_id.split(':')
    raise(ArgumentError, "This ead_id: #{ead_id} does not follow the expected format") if ids.count != 2
    @unit = ids[0]
    @identifier = ids[1]
  end

  def path
    "#{prefix}#{'/' unless prefix.nil?}#{unit}.xml##{identifier}"
  end

  def url
    "#{Rails.configuration.x.finding_aid_base}#{path}"
  end

  def prefix
    case @unit
    when *PREFIX_IDENTIFIERS[:rare]
      "RARE"
    when *PREFIX_IDENTIFIERS[:tri]
      "TRI"
    when *PREFIX_IDENTIFIERS[:byrd]
      "ByrdPolar"
    when *PREFIX_IDENTIFIERS[:ua]
      "UA"
    when *PREFIX_IDENTIFIERS[:cartoon]
      "Cartoons"
    end
  end
end
