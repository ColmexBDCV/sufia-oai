class ConacytStatsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  protect_from_forgery with: :null_session
  before_filter :authenticate, :only => 'padron'

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
  #articulos = WorkViewStat.group('work_id').count('work_id', :distinct => true) 
  def articulos

    a = { articulos: []}

      articulos = WorkViewStat.group(:work_id).sum(:work_views)

      articulos.each do |key, value|
        work = GenericWork.where(id: key)

        if !work.empty? then
          a[:articulos].push(
             {
                id: work[0].identifier,
                numero:  value
             } 
          )
        end
      end

      render :json => a
  end

  def autores

    a = { autores: []}

    works = WorkViewStat.group(:work_id).sum(:work_views)

    works.each do |key, value|
      work = GenericWork.where(id: key)

      if !work.empty? then

        esta = a[:autores].index { |h| h[:nombre] == work[0].creator }

        if esta then 
           
          a[:autores][esta][:numero] =  a[:autores][esta][:numero] + value

        else
            
          autor = work[0].creator
          a[:autores].push(
            {
              nombre: autor,
              numero:  value
            } 
          )
        end
      end
    end

    render :json => a
  end

  def descargas

    d = { descargas: []}

      descargas = FileDownloadStat.group(:file_id).sum(:downloads)

      descargas.each do |key, value|
        work_key = Fileset.where(id: key)
        work = GenericWork.where(work_key[0].parent)
        if !work.empty? then
          d[:descargasgas].push(
             {
                id: work[0].identifier,
                numero:  value
             } 
          )
        end
      end
      
      render :json => d
  end
end
