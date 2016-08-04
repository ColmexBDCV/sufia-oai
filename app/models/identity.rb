class Identity < ActiveRecord::Base
  belongs_to :user

  validates :uid, :provider, presence: true
  validates :uid, uniqueness: true, scope: :provider

  class << self
    def from_omniauth(auth)
      where(uid: auth.uid, provider: auth.provider).first_or_create do |identity|
        identity.user = User.from_omniauth(auth)
      end
    end
  end
end
