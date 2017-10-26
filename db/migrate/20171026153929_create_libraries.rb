class CreateLibraries < ActiveRecord::Migration[5.1]
  def change
    create_table :libraries do |t|
      t.references :user, index: true
      t.references :album, index: true
      t.string :state

      t.timestamps
    end
  end
end
