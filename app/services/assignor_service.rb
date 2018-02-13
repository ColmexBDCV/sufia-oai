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
      unless gw.creator.empty?
	      n = gw.creator[0].split(', ')

	      nombre = [ n[1], n[0] ].join(" ")

	      buscar = I18n.transliterate(nombre).gsub(/[^0-9A-Za-z  ]/, '').gsub(" ", "%20")

        conn = Faraday.new :url =>'http://catalogs.repositorionacionalcti.mx/webresources/', :headers => { :Authorization => "Basic #{ENV['CONACYT_AUTH']}"}

	      creator = conn.get "persona/byNombreCompleto/params;nombre=#{buscar}"

	      data = JSON.parse(creator.body.force_encoding('utf-8'))

	      unless data.empty?

		name = data[0].key?("nombres") ? data[0]["nombres"] : name+""
		name = data[0].key?("primerApellido") ? name+" "+data[0]["primerApellido"] : name+""
		name = data[0].key?("segundoApellido") ? name+" "+data[0]["segundoApellido"] : name+""

		gw.creator_conacyt = name
		gw.cvu = data[0].key?("idCvuConacyt") ? data[0]["idCvuConacyt"] : nil
		gw.orcid = data[0].key?("idOrcid") ? data[0]["idOrcid"] : nil
		gw.idpersona = data[0]['idPersona']
		gw.curp = data[0].key?("curp") ? data[0]["curp"] : nil
		gw.save

	      else

		gw.creator_conacyt = nil
		gw.cvu = nil
		gw.orcid = nil
		gw.idpersona = nil
		gw.curp = nil
		gw.save

	      end
	end
      num += 1
    end

  end
end
