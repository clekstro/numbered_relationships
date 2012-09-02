class AddNameToKinglyCourts < ActiveRecord::Migration
  def change
    add_column :kingly_courts, :name, :string
  end
end
