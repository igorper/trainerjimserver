class MigrateAdminTrainerFlags < ActiveRecord::Migration
  def self.up
    User.all.each {|user|
      user.roles.each {|role|
        if role.name == "Administrator"
          user.is_administrator = true
          puts("Setting user #{user.full_name} as administrator.")
        end
        if role.name == "Trainer"
          user.is_trainer = true
          puts("Setting user #{user.full_name} as trainer.")
        end
      }
      user.save
    }
  end
end
