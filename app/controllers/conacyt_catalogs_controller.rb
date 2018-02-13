class ConacytCatalogsController < ApplicationController
  protect_from_forgery with: :null_session

  def initialize
      @conn = Faraday.new :url => 'http://repositorio.colmex.mx:5050/'
  end


  def autor

    buscar = params[:phrase].gsub(" ", "%20")

    conn = Faraday.new :url =>'http://catalogs.repositorionacionalcti.mx/webresources/', :headers => { :Authorization => "Basic #{ENV['CONACYT_AUTH']}"}
    creator = conn.get "persona/byNombreCompleto/params;nombre=#{buscar}"

    data = JSON.parse(creator.body.force_encoding('utf-8'))

    # render json: data
    # return

    autores = []


    data.each do |dato|
      hash = {}
      # hash[:id] = dato["_id"]
      nombre = ""
      nombre = dato.key?("nombres") ? dato["nombres"] : nombre+""
      nombre = dato.key?("primerApellido") ? nombre+" "+dato["primerApellido"] : nombre+""
      nombre = dato.key?("segundoApellido") ? nombre+" "+dato["segundoApellido"] : nombre+""
      hash[:nombre] = nombre
      hash[:cvu] = dato.key?("idCvuConacyt") ?  dato["idCvuConacyt"] : nil
      hash[:orcid] = dato.key?("idOrcid") ?   dato["idOrcid"] : nil
      hash[:idPersona] = dato["idPersona"]

      #nombres.push({id: "#{dato["_id"]}", nombre: "#{dato["nombres"]} #{dato["primerApellido"]} #{dato["segundoApellido"]}", cvu: "#{dato["idCvuConacyt"]}", orcid: "#{dato[idOrcid]}"  })
      autores.push(hash)
    end

    render json: autores

  end

  def index
    # Authorization : Basic ZWNtOkVjTTA1XzA2




    # areacono = conn.get 'areacono'
    # @api = { areacono: JSON.parse(areacono.body.force_encoding('utf-8')) }
    # campocono = conn.get 'campocono'
    # @api[:campocono] = JSON.parse(campocono.body.force_encoding('utf-8'))
    # disciplinacono = conn.get 'disciplinacono'
    # @api[:disciplinacono] = JSON.parse(disciplinacono.body.force_encoding('utf-8'))

  end

  def persona_name


    palabra = params[:phrase].gsub(" ", "%20")

    # persona = @conn.get "persona/byNombreCompleto/params;nombre=#{palabra};limit=20"
    persona = @conn.get "api/personas/#{palabra}"
    #persona = @conn.post "api/personas", { :nombre => palabra}
    data = JSON.parse(persona.body.force_encoding('utf-8'))

    nombres = []

    data.each do |dato|
      hash = {}
      hash[:id] = dato["_id"]
      nombre = ""
      nombre = dato.key?("nombres") ? dato["nombres"] : nombre+""
      nombre = dato.key?("primerApellido") ? nombre+" "+dato["primerApellido"] : nombre+""
      nombre = dato.key?("segundoApellido") ? nombre+" "+dato["segundoApellido"] : nombre+""
      hash[:nombre] = nombre
      hash[:cvu] = dato.key?("idCvuConacyt") ?   dato["idCvuConacyt"] : nil
      hash[:orcid] = dato.key?("idOrcid") ?   dato["idOrcid"] : nil

      #nombres.push({id: "#{dato["_id"]}", nombre: "#{dato["nombres"]} #{dato["primerApellido"]} #{dato["segundoApellido"]}", cvu: "#{dato["idCvuConacyt"]}", orcid: "#{dato[idOrcid]}"  })
      nombres.push(hash)
    end

    render json: nombres
  end
end
