class AddPublicTokenToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :public_token, :string
  end
end
