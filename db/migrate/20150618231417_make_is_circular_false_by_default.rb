class MakeIsCircularFalseByDefault < ActiveRecord::Migration
  def change
    change_column :trainings, :is_circular, :boolean, default: false
  end
end
