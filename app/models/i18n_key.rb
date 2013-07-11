# == Schema Information
#
# Table name: i18n_keys
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class I18nKey < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  
  has_many :i18n_string
end
