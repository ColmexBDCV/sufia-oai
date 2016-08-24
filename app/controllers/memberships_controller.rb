class MembershipsController < ApplicationController
  load_and_authorize_resource

  # DELETE /units/:unit_id/memberships/:id
  def destroy
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to edit_unit_path(@membership.unit), notice: "#{@membership.user.name} was removed from #{@membership.unit.name}" }
      format.json { head :no_content }
    end
  end
end
