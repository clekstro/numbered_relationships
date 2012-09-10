class CreateDramaticMoments < ActiveRecord::Migration
  def change
    create_table :dramatic_moments do |t|
      t.integer :duration
      t.references :artistic_pause

      t.timestamps
    end
  end
end
