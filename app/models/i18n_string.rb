class I18nString < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  
  belongs_to :i18n_key
end
