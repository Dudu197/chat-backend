class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :text
      t.references :sender
      t.references :receiver
      t.datetime :read_at, default: nil

      t.timestamps
    end
  end
end
