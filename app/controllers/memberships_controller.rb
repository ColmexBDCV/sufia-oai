class MembershipsController < ApplicationController
  before_action :set_membership, only: [:update, :destroy]
  before_action :set_unit

  # POST /units/:unit_id/memberships
  def create
    @membership = Membership.new(membership_params)
    @membership.unit = @unit

    respond_to do |format|
      if @membership.save
        format.html { redirect_to @unit, notice: "#{@membership.user.name} was added to #{@unit.name}" }
        format.json { render :show, status: :created, location: @unit }
      else
        format.html { redirect_to @unit, notice: "User could not be added to unit." }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /units/:unit_id/memberships/:id
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @unit, notice: "The access level of #{@membership.user.name} was updated." }
        format.json { render :show, status: :ok, location: @unit }
      else
        format.html { redirect_to @unit, notice: "There was an error updating the user's membership." }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /units/:unit_id/memberships/:id
  def destroy
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to @unit, notice: "#{@membership.user.name} was removed from #{@unit.name}" }
      format.json { head :no_content }
    end
  end

  private

  def set_membership
    @membership = Membership.find(params[:id])
  end

  def set_unit
    @unit = Unit.find(params[:unit_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def membership_params
    params.require(:membership).permit(:user_id, :level)
  end
end
