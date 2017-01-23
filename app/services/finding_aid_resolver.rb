class FindingAidResolver
  PREFIX_IDENTIFIERS = {
    rare: [/SPEC.RARE/],
    tri: [/SPEC.TRI/],
    byrd: [/SPEC.PA.56/, /SPEC.RG.56/, /RG 56/],
    ua: [/RG/],
    cartoon: [/SPEC.CGA/]
  }.freeze

  attr_reader :collection, :identifier

  # ead_id format ex: +//ISIL US-ou//TEXT EAD::SPEC.RARE.0137::ref11//EN
  def initialize(ead_id)
    parts = ead_id.strip.match(%r"^\+//ISIL US-[\w]{1,2}//TEXT EAD::([-\w\. ]+)(?:::([-\w\. ]+))?(?://[A-Z]{2})?$")
    raise(ArgumentError, "#{ead_id} does not follow the expected format") unless parts.try(:[], 1)
    @collection = parts[1]
    @identifier = parts[2]
  end

  def path
    @path || begin
               @path = "#{collection}.xml"
               @path.prepend("#{prefix}/") if prefix
               @path << "##{identifier}" if identifier
               @path
             end
  end

  def url
    "#{Rails.configuration.x.finding_aid_base}#{path}"
  end

  def prefix
    return @prefix if defined? @prefix
    @prefix = case @collection
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

  def short_id
    "#{collection}#{'::' if identifier}#{identifier}"
  end
end
