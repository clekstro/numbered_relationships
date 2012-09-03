class CreateLaughs < ActiveRecord::Migration
  def change
    create_table :laughs do |t|
      t.integer :volume

      t.timestamps
    end
  end
end
