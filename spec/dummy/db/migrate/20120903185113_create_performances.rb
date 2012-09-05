class CreatePerformances < ActiveRecord::Migration
  def change
    create_table :performances do |t|
      t.string :name

      t.timestamps
    end
  end
end
