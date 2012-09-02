class AddJoinTableJestersKinglyCourts < ActiveRecord::Migration
  def up
    create_table :jesters_kingly_courts do |t|
      t.integer :kingly_court_id
      t.integer :jester_id
    end
  end


  def down
    drop_table :jesters_kingly_courts
  end
end
