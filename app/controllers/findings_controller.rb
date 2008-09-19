#

class FindingsController < ApplicationController
  before_filter :require_person
  def create
    Finding.transaction do
      finding = Finding.new
      finding.person = current_person
      finding.image = existing_or_new_image(params[:src], params[:title])
      finding.tag_list = params[:tag_list]
      finding.save!
      flash[:success] = "saved!"
      redirect_to(root_url)
    end
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

  protected
    def existing_or_new_image (src, title)
      image = Image.find_by_src(src)
      image ||= Image.new
      image.src = src
      image.title = title if image.new_record?
      image.save!
      image
    end
end
