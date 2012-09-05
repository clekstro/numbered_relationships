class CreateRepertoires < ActiveRecord::Migration
  def change
    create_table :repertoires do |t|
      t.integer :jester_id

      t.timestamps
    end
  end
end
