class AdminPolicy < Hydra::AdminPolicy
  accepts_nested_attributes_for :default_permissions, allow_destroy: true

  after_create :include_admin

  # When changing a permission for an object/user, ensure an update is done, not a duplicate
  def default_permissions_attributes_with_uniqueness=(attributes_collection)
    if attributes_collection.is_a? Hash
      if (attributes_collection.keys & ['id', :id]).any?
        attributes_collection = Array(attributes_collection)
      else
        attributes_collection.sort_by! { |i, _| i.to_i }.map { |_, attributes| attributes }
      end
    end

    attributes_collection.each do |prop|
      existing = default_permissions.to_a.select { |p| send("#{prop[:type]}_agent?", p.agent) }

      next unless existing
      selected = existing.find { |perm| perm.agent_name == prop[:name] }
      prop['id'] = selected.id if selected
    end

    self.default_permissions_attributes_without_uniqueness = attributes_collection
  end

  alias_method :default_permissions_attributes_without_uniqueness=, :default_permissions_attributes=
  alias_method :default_permissions_attributes=, :default_permissions_attributes_with_uniqueness=

  private

  def include_admin
    groups = default_permissions.each.collect(&:agent_name)
    unless groups.include? "Administrators"
      self.default_permissions_attributes = [{ type: "group", access: "edit", name: "Administrators" }]
      save
    end
  end
end
