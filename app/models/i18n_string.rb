# == Schema Information
#
# Table name: i18n_strings
#
#  id          :integer          not null, primary key
#  i18n_key_id :integer
#  locale      :string(255)
#  data        :text
#  created_at  :datetime
#  updated_at  :datetime
#

class I18nString < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  
  belongs_to :i18n_key
end
