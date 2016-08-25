class UnitsController < ApplicationController
  load_and_authorize_resource

  # GET /units
  # GET /units.json
  def index
    @units = Unit.all
  end

  # GET /units/1
  # GET /units/1.json
  def show
  end

  # GET /units/new
  def new
    @unit = Unit.new
  end

  # GET /units/1/edit
  def edit
    @membership = Membership.new(unit: @unit)
  end

  # POST /units
  # POST /units.json
  def create
    @unit = Unit.new(create_params)

    respond_to do |format|
      if @unit.save
        format.html { redirect_to @unit, notice: 'Unit was successfully created.' }
        format.json { render :show, status: :created, location: @unit }
      else
        format.html { render :new }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /units/1
  # PATCH/PUT /units/1.json
  def update
    respond_to do |format|
      if @unit.update(update_params)
        format.html { redirect_to @unit, notice: 'Unit was successfully updated.' }
        format.json { render :show, status: :ok, location: @unit }
      else
        format.html { render :edit }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    @unit.destroy
    respond_to do |format|
      format.html { redirect_to units_url, notice: 'Unit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_unit
    @unit = Unit.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def create_params
    params.require(:unit).permit(:name, :description, :contact_info, :key, :image, 
      memberships_attributes: [:id, :user_id, :level, :_destroy])
  end

  def update_params
    create_params.except(:key)
  end
end
