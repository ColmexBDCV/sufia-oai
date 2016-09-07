class Unit < ActiveRecord::Base
  include FedoraObjectAssociations

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  belongs_to :admin_policy

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"

  after_create :add_admin_policy

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates :key, :name, presence: true
  validates :key, format: { with: /^[-a-z]+$/, message: "only allows letters, numbers and hyphens" }

  accepts_nested_attributes_for :memberships, allow_destroy: true

  private

  def add_admin_policy
    admin_policy = AdminPolicy.create
  end
end
