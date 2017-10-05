class ConacytCatalogsController < ApplicationController
  protect_from_forgery with: :null_session

  def initialize
    # @conn = Faraday.new :url =>'http://catalogs.repositorionacionalcti.mx/webresources/', :headers => { :Authorization => 'Basic ZWNtOkVjTTA1XzA2'}
      @conn = Faraday.new :url => 'http://localhost:5050/'
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
      nombres.push({ nombre: "#{dato["nombres"]} #{dato["primerApellido"]} #{dato["segundoApellido"]}" })
    end

    render json: nombres

  end
end
