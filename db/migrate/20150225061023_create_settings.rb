class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :key, null: false
      t.string :value, null: false
      t.references :customization, index: true

      t.timestamps null: false
    end
    add_foreign_key :settings, :customizations
  end
end
