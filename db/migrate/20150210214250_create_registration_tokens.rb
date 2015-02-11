class CreateRegistrationTokens < ActiveRecord::Migration
  def change
    create_table :registration_tokens do |t|
      t.string :token, unique: true
    end
  end
end
