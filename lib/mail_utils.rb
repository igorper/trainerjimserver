module MailUtils
  # Extracts the user's name from the given email. For example, if the email
  # is
  #     "john.smith_martin+goblin-junior@something.com"
  # the returned string will be
  #     "John Smith Martin Goblin Junior"
  # 
  # @param email string An email string (e.g.: "john.smith_martin+goblin-junior@something.com").
  # 
  # @return string the extracted name (e.g.: "John Smith Martin Goblin Junior").
  # 
  # @throw An exception is thrown if the email could not be parsed.
  #
  def MailUtils.extract_display_name(email)
      require 'mail'
      require 'unicode'
      return Mail::Address.new(email).local.split(/[+\-\._]/).map{ |v| Unicode::capitalize(v) }.join(' ')
  end
end