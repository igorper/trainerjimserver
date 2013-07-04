class I18nKey < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  
  has_many :i18n_string
end
