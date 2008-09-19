#

class WelcomeController < ApplicationController
  def index
    @recent_images = Image.paginate(
      :per_page => current_per_page,
      :page => current_page, 
      :select => "images.*, count(*) as popularity",
      :joins => "JOIN findings ON findings.image_id = images.id",
      :group => "findings.image_id",
      :order => "popularity DESC"
    )
  end
end
