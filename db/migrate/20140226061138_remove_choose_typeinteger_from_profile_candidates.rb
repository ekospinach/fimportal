class RemoveChooseTypeintegerFromProfileCandidates < ActiveRecord::Migration
  def up
    remove_column :profile_candidates, :choose_type
  end

  def down
    add_column :profile_candidates, :choose_type, :integer
  end
end
