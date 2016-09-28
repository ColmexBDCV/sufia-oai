class User < ActiveRecord::Base
  include Hydra::User
  include CurationConcerns::User
  include Sufia::User
  include Sufia::UserUsageStats

  has_many :identities, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :units, -> { distinct }, through: :memberships

  def groups
    groups = units.each.collect(&:key)
    admin? ? groups << "Administrators" : groups
  end

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :password, :password_confirmation
  end
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :omniauthable

  class << self
    def from_omniauth(auth)
      where(email: auth.info.email).first_or_create do |user|
        user.password = Devise.friendly_token[0, 20]
        user.display_name = auth.info.name
      end
    end
  end

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  def in_unit?
    units.any?
  end

  def manager?
    has_membership_of_level? Membership::MANAGER_LEVEL
  end

  def curator?
    has_membership_of_level? Membership::CURATOR_LEVEL
  end

  def member_of?(unit, opts={})
    opts = { level: Membership::MANAGER_LEVEL }.merge(opts)
    unit = unit.is_a?(Unit) ? unit : Unit.find_by_key(unit)
    memberships.where(unit: unit, level: opts[:level]).any?
  end

  private

  def has_membership_of_level?(level)
    memberships.where(level: level).any?
  end
end
