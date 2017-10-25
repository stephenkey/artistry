class CreateGenres < ActiveRecord::Migration[5.1]
  def change
    create_table :genres do |t|
      t.string :name
      t.integer :albums_count, default: 0

      t.timestamps
    end
  end
end
