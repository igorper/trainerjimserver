# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)
#  full_name              :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  trainer_id             :integer
#

class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # attr_accessible :id, :email, :password, :password_confirmation, :remember_me,
  # :full_name, :trainer, :roles

  belongs_to :trainer, :class_name => "User", :foreign_key => 'trainer_id'
  has_many :measurements, :dependent => :delete_all
  has_many :trainees, class_name: :User, foreign_key: :trainer_id
  has_and_belongs_to_many :roles

  def display_name
    if self.full_name.blank? then
      require 'mail_utils'
      return MailUtils::extract_display_name(self.email)
    else
      return self.full_name
    end
  end

  def unique_display_name
    "#{self.display_name} (#{self.email})"
  end

  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end

  def administrator?
    return !!self.roles.find_by_name(Role.administrator)
  end

  def trainer?
    return !!self.roles.find_by_name(Role.trainer)
  end
end
