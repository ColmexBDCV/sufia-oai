class User < ActiveRecord::Base
  include Hydra::User
  include CurationConcerns::User
  include Sufia::User
  include Sufia::UserUsageStats

  has_many :identities, dependent: :destroy

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
end
