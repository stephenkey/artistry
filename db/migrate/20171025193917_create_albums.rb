class CreateAlbums < ActiveRecord::Migration[5.1]
  def change
    create_table :albums do |t|
      t.references :genre, index: true
      t.references :artist, index: true
      t.string :name
      t.string :published
      t.string :last_fm_url
      t.integer :tracks_count, default: 0

      t.timestamps
    end
  end
end
