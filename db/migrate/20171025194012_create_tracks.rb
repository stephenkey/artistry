class CreateTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks do |t|
      t.references :album, index: true
      t.string :name
      t.integer :order, default: 0
      t.integer :seconds, default: 0
      t.string :last_fm_url

      t.timestamps
    end
  end
end
