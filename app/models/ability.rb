class Ability
  include Hydra::PolicyAwareAbility
  include CurationConcerns::Ability
  include Sufia::Ability

  # Define any customized permissions here.
  def custom_permissions
    can :create, GenericWork if current_user.in_unit?

    can :create, Collection if registered_user?

    can :read, Unit
    can [:update, :curate], Unit, memberships: { user_id: current_user.id, level: 'Manager' }
    can :curate, Unit, memberships: { user_id: current_user.id, level: 'DataEntry' }

    can :manage, :all if current_user.admin?
  end
end
