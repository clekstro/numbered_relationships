class CreateDramaticMoments < ActiveRecord::Migration
  def change
    create_table :dramatic_moments do |t|
      t.integer :duration
      t.integer :artistic_pause_id

      t.timestamps
    end
  end
end
