class CreateI18n < ActiveRecord::Migration
  def change
    create_table :i18n_keys do |t|
      t.string :key
      
      t.timestamps
    end
    
    add_index :i18n_keys, :key, :unique => true
    
    create_table :i18n_strings do |t|
      t.integer :i18n_key_id
      t.string :locale
      t.text :data
      
      t.foreign_key :i18n_keys, :column => 'i18n_key_id', :dependent => :delete, :on_update => :cascade
      
      t.timestamps
    end
    
    add_index :i18n_strings, :i18n_key_id
    add_index :i18n_strings, :locale
  end
end
