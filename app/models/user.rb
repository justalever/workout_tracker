class User < ApplicationRecord
  after_create :create_tenant
  after_destroy :delete_tenant

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, request_keys: [:subdomain]

  has_many :workouts, dependent: :destroy

  validates :email, uniqueness: true

  def create_tenant
    Apartment::Tenant.create(subdomain)
  end

  def delete_tenant
    Apartment::Tenant.drop(subdomain)
  end

   def self.find_for_authentication(warden_conditions)
    where(:email => warden_conditions[:email], :subdomain => warden_conditions[:subdomain]).first
  end
end
