class CreateJesters < ActiveRecord::Migration
  def change
    create_table :jesters do |t|
      t.string :name

      t.timestamps
    end
  end
end
