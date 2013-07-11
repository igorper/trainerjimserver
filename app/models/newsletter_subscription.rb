# == Schema Information
#
# Table name: newsletter_subscriptions
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'valid_email'

class NewsletterSubscription < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  
  validates :email, :presence => true, :email => true
end
