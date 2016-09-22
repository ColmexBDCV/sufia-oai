class Unit < ActiveRecord::Base
  include FedoraObjectAssociations

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  belongs_to :admin_policy

  before_create :add_admin_policy

  has_attached_file :image, styles: { landing: "300x200#", medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates :key, :name, presence: true
  validates :key, uniqueness: true, format: { with: /\A[-a-z1-9]+\z/, message: "only allows letters, numbers and hyphens" }

  accepts_nested_attributes_for :memberships, allow_destroy: true

  private

  def add_admin_policy
    create_admin_policy default_permissions_attributes: [{ type: "group", access: "edit", name: key }]
  end
end
