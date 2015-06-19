class RemoveI18n < ActiveRecord::Migration
  def change
    drop_table :i18n_strings
    drop_table :i18n_keys
  end
end
