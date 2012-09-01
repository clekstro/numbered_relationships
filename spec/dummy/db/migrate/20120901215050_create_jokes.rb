class CreateJokes < ActiveRecord::Migration
  def change
    create_table :jokes do |t|

      t.timestamps
    end
  end
end
