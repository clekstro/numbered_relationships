class CreateArtisticPauses < ActiveRecord::Migration
  def change
    create_table :artistic_pauses do |t|
      t.integer :duration
      t.integer :performance_id

      t.timestamps
    end
  end
end
