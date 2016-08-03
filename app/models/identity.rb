class Identity < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  class << self
    def from_omniauth(auth)
      identity = where(uid: auth.uid, provider: auth.provider).first_or_create do |identity|
        identity.user = User.from_omniauth(auth)
      end
    end
  end
end
