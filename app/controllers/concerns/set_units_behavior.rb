module SetUnitsBehavior
  extend ActiveSupport::Concern

  included do
    before_action :set_units, only: [:new, :edit]
  end

  private

  def set_units
    @units = current_user.admin? ? Unit.all : Unit.where(key: current_user.groups)
  end
end
