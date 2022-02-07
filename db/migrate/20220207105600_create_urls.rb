class CreateUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :urls do |t|
      t.string :token
      t.text :original_url

      t.timestamps
    end
    add_index :urls, :token, unique: true
  end
end
