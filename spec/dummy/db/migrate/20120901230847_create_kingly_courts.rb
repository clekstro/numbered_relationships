class CreateKinglyCourts < ActiveRecord::Migration
  def change
    create_table :kingly_courts do |t|

      t.timestamps
    end
  end
end
