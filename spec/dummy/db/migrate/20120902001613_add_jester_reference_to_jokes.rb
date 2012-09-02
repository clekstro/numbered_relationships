class AddJesterReferenceToJokes < ActiveRecord::Migration
  def change
    add_column :jokes, :jester_id, :integer
  end
end
