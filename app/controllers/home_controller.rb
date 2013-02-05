class HomeController < ApplicationController
  def index
    @test_var = "This is a test var!"
    @u = User.find_by_email 'igor.pernek@gmail.com'
  end
end
