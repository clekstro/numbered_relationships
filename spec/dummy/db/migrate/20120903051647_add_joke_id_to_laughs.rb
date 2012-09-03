class AddJokeIdToLaughs < ActiveRecord::Migration
  def change
    add_column :laughs, :joke_id, :integer
  end
end
