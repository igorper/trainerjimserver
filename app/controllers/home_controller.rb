class HomeController < ApplicationController
  def index
    @test_var = "This is a test var!"
    @u = User.find_by_email 'matej.urbas@gmail.com'
  end
end
