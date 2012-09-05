class AddKinglyCourtsPerformancesJoinTable < ActiveRecord::Migration
  def up
  	create_table :kingly_courts_performances do |t|
  		t.references :kingly_court
  		t.references :performance
  	end
  end

  def down
  	drop_table :kingly_courts_performances
  end
end
