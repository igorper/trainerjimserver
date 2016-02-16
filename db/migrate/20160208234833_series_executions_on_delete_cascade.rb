class SeriesExecutionsOnDeleteCascade < ActiveRecord::Migration
  def change
    remove_foreign_key :series_executions, :measurements
    add_foreign_key :series_executions, :measurements, column: :measurement_id, on_delete: :cascade, on_update: :cascade

    remove_foreign_key "conversations", "measurements"
    add_foreign_key "conversations", "measurements", on_update: :cascade, on_delete: :cascade

    remove_foreign_key "conversations", column: "sender_id"
    add_foreign_key "conversations", "users", column: "sender_id", on_update: :cascade, on_delete: :cascade

    remove_foreign_key "measurement_comments", "series_executions"
    add_foreign_key "measurement_comments", "series_executions", on_update: :cascade, on_delete: :cascade
  end
end
