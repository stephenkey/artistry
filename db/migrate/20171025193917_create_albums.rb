class CreateAlbums < ActiveRecord::Migration[5.1]
  def change
    create_table :albums do |t|
      t.references :genre, index: true
      t.references :artist, index: true
      t.string :title
      t.string :state
      t.integer :year
      t.integer :seconds, default: 0
      t.integer :tracks_count, default: 0

      t.timestamps
    end
  end
end
