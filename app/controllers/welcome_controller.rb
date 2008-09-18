#

class WelcomeController < ApplicationController
  def index
    @image = Image.new
  end
end
