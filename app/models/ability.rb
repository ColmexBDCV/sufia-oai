class Ability
  include Hydra::PolicyAwareAbility
  include CurationConcerns::Ability
  include Sufia::Ability

  self.ability_logic += [:delete_permissions, :import_permissions]

  def self.model_class_field
    ActiveFedora.index_field_mapper.solr_name("has_model", :symbol)
  end

  # Define any customized permissions here.
  def custom_permissions
    can :create, ActiveFedora::Base if current_user.in_unit?

    can :create, Collection if current_user.in_unit?

    can :read, Unit
    can [:update, :curate, :destroy], Unit, memberships: { user_id: current_user.id, level: Membership::MANAGER_LEVEL }
    can :curate, Unit, memberships: { user_id: current_user.id, level: [Membership::DATA_ENTRY_LEVEL, Membership::CURATOR_LEVEL] }

    can :manage, :all if current_user.admin?
  end

  def import_permissions
    # Reset all permissions on Imports
    cannot :manage, Import

    import_user_abilities if current_user.manager? || current_user.curator?
    import_admin_abilities if current_user.admin?
  end

  def import_user_abilities
    can :create, Import
    can [:read, :row_preview, :image_preview], Import, user_id: current_user.id
    can :start, Import, status: Import.statuses[:ready], user_id: current_user.id
    can [:undo, :finalize], Import, status: Import.statuses[:complete], user_id: current_user.id
    can :resume, Import do |import|
      import.user_id == current_user.id && import.resumable?
    end
    can [:update, :destroy, :browse], Import do |import|
      import.user_id == current_user.id && import.editable?
    end
    can :report, Import do |import|
      import.user_id == current_user.id && import.reportable?
    end
  end

  def import_admin_abilities
    can [:create, :read, :row_preview, :image_preview, :view_all], Import
    can :start, Import, status: Import.statuses[:ready]
    can [:undo, :finalize], Import, status: Import.statuses[:complete]
    can :resume, Import, &:resumable?
    can [:update, :destroy, :browse], Import, &:editable?
    can :report, Import, &:reportable?
  end

  def edit_permissions
    can [:edit, :update], String do |id|
      test_edit(id)
    end

    can [:edit, :update], ActiveFedora::Base do |obj|
      test_edit(obj.id)
    end

    can [:edit, :update], SolrDocument do |obj|
      cache.put(obj.id, obj)
      test_edit(obj.id)
    end
  end

  def delete_permissions
    can [:destroy], String do |id|
      test_delete(id)
    end

    can [:destroy], ActiveFedora::Base do |obj|
      test_delete(obj.id)
    end

    can [:destroy], SolrDocument do |obj|
      cache.put(obj.id, obj)
      test_delete(obj.id)
    end
  end

  protected

  def test_delete(id)
    Rails.logger.debug("[CANCAN] Checking delete permissions for user: #{current_user.user_key} with groups: #{user_groups.inspect}")
    unit = managing_unit_for permissions_doc(id)

    if unit
      Rails.logger.debug("[CANCAN] Unit ID is: #{unit}")
      result = current_user.member_of? unit, level: Membership::MANAGER_LEVEL
    else
      group_intersection = user_groups & edit_groups(id)
      result = !group_intersection.empty? || edit_users(id).include?(current_user.user_key)
    end

    Rails.logger.debug("[CANCAN] decision: #{result}")
    result
  end

  def managing_unit_for(doc)
    unit = doc.try(:[], 'unit_ssim')
    unit&.first || unit
  end
end
