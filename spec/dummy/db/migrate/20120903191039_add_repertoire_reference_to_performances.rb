class AddRepertoireReferenceToPerformances < ActiveRecord::Migration
  def change
    add_column :performances, :repertoire_id, :integer
  end
end
