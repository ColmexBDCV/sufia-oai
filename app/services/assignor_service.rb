module AssignorService
  mattr_accessor :authority

  def self.assign
    

    GenericWork.where(creator_conacyt:nil).each do |gw|

      n = gw.creator[0].split(', ')

      nombre = [ n[1], n[0] ].join(" ")

      buscar = I18n.transliterate(nombre).gsub(/[^0-9A-Za-z  ]/, '').gsub(" ", "%20")
      
      conn = Faraday.new :url =>'http://catalogs.repositorionacionalcti.mx/webresources/', :headers => { :Authorization => 'Basic ZWNtOkVjTTA1XzA2'}
      
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
        gw.save
      
      end
    
    end

  end
end
