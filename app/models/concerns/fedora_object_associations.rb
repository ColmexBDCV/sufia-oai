module FedoraObjectAssociations
  extend ActiveSupport::Concern

  included do
    if defined? after_initialize
      after_initialize do
        init_fedora_association_cache
      end
    end
  end

  def initialize(*args)
    super
    init_fedora_association_cache
  end

  module ClassMethods
    def belongs_to(name, scope = nil, opts = {})
      opts = scope if scope.is_a? Hash
      opts = {
        foreign_key: "#{name}_id",
        class_name: name.to_s.classify,
        primary_key: 'id'
      }.merge(opts)
      fedora_class = opts[:class_name].constantize

      if fedora_class <= ActiveFedora::Base
        define_method(name) do
          unless fedora_association_cached?(name)
            fedora_object = find_fedora_belongs_to(fedora_class, opts[:foreign_key], opts[:primary_key])
            set_cached_fedora_association(name, fedora_object)
          end

          get_cached_fedora_association(name)
        end

        define_method("#{name}=") do |obj|
          raise AssociationTypeMismatch, "#{obj.class} is not a #{fedora_class}!" unless obj.nil? || obj.is_a?(fedora_class)
          send("#{opts[:foreign_key]}=", obj.try(opts[:primary_key]))
          remove_cached_fedora_association(name)
          send(name)
        end

        define_method("create_#{name}") do |attributes = {}|
          obj = fedora_class.send(:create, attributes)
          send("#{name}=", obj)
        end
      else
        super
      end
    end

    # rubocop:disable Style/PredicateName, Metrics/PerceivedComplexity
    def has_one(name, scope = nil, opts = {})
      opts = scope if scope.is_a? Hash
      opts = {
        foreign_key: "#{self.class.name.underscore}_id",
        class_name: name.to_s.classify,
        primary_key: 'id'
      }.merge(opts)
      fedora_class = opts[:class_name].constantize

      if fedora_class <= ActiveFedora::Base
        define_method(name) do
          unless fedora_association_cached?(name)
            fedora_object = find_fedora_has_one(fedora_class, opts[:foreign_key], opts[:primary_key])
            set_cached_fedora_association(name, fedora_object)
          end

          get_cached_fedora_association(name)
        end

        define_method("#{name}=") do |obj|
          raise AssociationTypeMismatch, "#{obj.class} is not a #{fedora_class}!" unless obj.nil? || obj.is_a?(fedora_class)

          current_obj = send(name)
          unless current_obj.nil?
            current_obj.send("#{opts[:foreign_key]}=", nil)
            current_obj.save
          end

          unless obj.nil?
            obj.send("#{opts[:foreign_key]}=", send(opts[:primary_key]))
            obj.save
          end

          remove_cached_fedora_association(name)
          send(name)
        end

        define_method("create_#{name}") do |attributes = {}|
          obj = fedora_class.send(:create, attributes)
          send("#{name}=", obj)
        end
      else
        super
      end
    end
    # rubocop:enable Style/PredicateName, Metrics/PerceivedComplexity
  end

  private

  def init_fedora_association_cache
    @fedora_association_cache = {} unless defined? @fedora_association_cache
  end

  def fedora_association_cached?(name)
    @fedora_association_cache.key?(name)
  end

  def get_cached_fedora_association(name)
    @fedora_association_cache[name]
  end

  def set_cached_fedora_association(name, obj)
    @fedora_association_cache[name] = obj
  end

  def remove_cached_fedora_association(name)
    @fedora_association_cache.delete(name) if fedora_association_cached?(name)
  end

  # rubocop:disable Rails/FindBy
  def find_fedora_belongs_to(klass, foreign_key, primary_key)
    return if send(foreign_key).blank?

    if primary_key.to_s == 'id'
      klass.find(send(foreign_key))
    else
      klass.where(primary_key => send(foreign_key)).first
    end
  end

  def find_fedora_has_one(klass, foreign_key, primary_key)
    return if send(primary_key).blank?
    klass.where(foreign_key => send(primary_key)).first
  end
  # rubocop:enable Rails/FindBy

  class AssociationTypeMismatch < StandardError
  end
end
