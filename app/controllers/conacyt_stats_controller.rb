class ConacytStatsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  protect_from_forgery with: :null_session
  before_filter :authenticate

  def authenticate
    authenticate_or_request_with_http_basic do |user, password|
      user == "ecm" && password == "EcM05_06"
    end
  end

  def padron
    usuarios = User.select('email, firstname, phone, paternal_surname, maternal_surname').all()

    d = { depositarios: []}

    usuarios.each do |u|
        d[:depositarios].push(
          {
            correo: u.email,
            nombre: u.firstname,
            numTel: u.phone,
            pApellido: u.paternal_surname,
            sApellido: u.maternal_surname

          }
        )
    end

    render :json => d

  end

end
