module AssignorService
  mattr_accessor :authority

  def self.check
    data = []
    # ActiveFedora::Base.where('has_model_ssim:GenericWork -creator_conacyt_tesim:["" TO *]').each do |g|
    GenericWork.where('idpersona_isim:[* TO *]-idpersona_isim:0').each do |g|

      d = {}
      d['titulo'] = g.title
      d['unidad'] = g.unit
      if g.file_set_ids.any?
        idfile = g.file_set_ids[0]
        d['archivo'] = FileSet.find(idfile).label
      end
      d['autor'] = g.creator
      d['identificador'] = g.identifier
      d['url'] = "http://repositorio.colmex.mx/concern/generic_works/#{g.id}"
      d['autor_conacyt'] = g.creator_conacyt

      data.push(d)

    end
    puts data.to_json
  end

  def self.assign

    num = 1
    GenericWork.all.each do |gw|
      puts num
      creator = []
      contributor = []
      [:creator, :contributor].each do |p|
        unless gw.creator.empty?
          gw.send(p).each do |c|
            n = c.split(', ')

            nombre = [ n[1], n[0] ].join(" ")

            buscar = I18n.transliterate(nombre).gsub(/[^0-9A-Za-z  ]/, '').gsub(" ", "%20")

            conn = Faraday.new :url =>'http://catalogs.repositorionacionalcti.mx/webresources/', :headers => { :Authorization => "Basic #{ENV['CONACYT_AUTH']}"}

            a = conn.get "persona/byNombreCompleto/params;nombre=#{buscar}"

            begin
              data = JSON.parse(a.body.force_encoding('utf-8'))
            rescue JSON::ParserError
              data = {}
            end

            unless data.empty?

              autor = ""

              data[0].each do |key, value|
                if autor == ""
                  autor += "#{key}: #{value}\n"
                else
                  autor += "#{key}: #{value}\n"
                end
              end
              if p == :creator
                creator.push(autor)
              elsif p == :contributor
                contributor.push(autor)
              end
            end
          end
        end
      end
      # puts "\n\n\n\n\n"
      # puts creator
      # puts "\n\n\n\n\n"
      # puts contributor
      # puts "\n\n\n\n\n"
      unless creator.empty?
        gw.creator_conacyt = creator
        gw.save
      else
        gw.creator_conacyt = nil
        gw.save
      end
      unless contributor.empty?
        gw.contributor_conacyt = contributor
        gw.save
      else
        gw.contributor_conacyt = nil
        gw.save
      end
      num += 1
    end

  end
end
