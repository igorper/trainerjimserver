class AddRepetitionTempoToSeries < ActiveRecord::Migration
  def change
    add_column :series, :duration_after_repetition, :integer
    add_column :series, :duration_up_repetition, :integer
    add_column :series, :duration_middle_repetition, :integer
    add_column :series, :duration_down_repetition, :integer
  end
end
