#

class FindingsController < ApplicationController
  def create
    image = Image.new
    image.title = params[:title]
    image.src = params[:src]
    finding = Finding.new
    finding.image = image
    finding.tag_list = params[:tag_list]
    @current_person.findings << finding
    @current_person.save!
    redirect_to(root_url)
  end
  def duplicate
    image = Image.find(params[:image_id])
    finding = Finding.new
    finding.image = image
    finding.tag_list = params[:tag_list]
    @current_person.findings << finding
    @current_person.save!
    redirect_to(root_url)
  end
end
