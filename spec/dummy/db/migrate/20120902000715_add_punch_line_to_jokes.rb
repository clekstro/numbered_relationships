class AddPunchLineToJokes < ActiveRecord::Migration
  def change
    add_column :jokes, :punch_line, :string
    add_column :jokes, :funny, :boolean
  end
end
