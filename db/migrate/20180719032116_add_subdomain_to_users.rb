class AddSubdomainToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :subdomain, :string
  end
end
