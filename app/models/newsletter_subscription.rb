require 'valid_email'

class NewsletterSubscription < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  
  validates :email, :presence => true, :email => true
end
