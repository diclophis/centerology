#

class FindingsController < ApplicationController
  before_filter :require_person
  def new
    session[:bookmarklet] = params[:bookmarklet]
    @image = Image.find_by_src(params[:image][:src])
    @image ||= Image.new
    @image.src = params[:image][:src]
    @image.title = params[:image][:title]
    if @image.new_record? then
      @finding = Finding.new
    else
      @finding = Finding.find_by_person_id_and_image_id(current_person, @image)
    end
    @finding.tag_list = params[:tag_list]
    #maybe? @image.title = title if image.new_record?
    if request.post? then
      begin
        Finding.transaction do
          @finding.person = current_person
          @finding.image = @image
          blob = Fast.fetch(@image.src)
          @image.x_put(blob)
          @image.save!
          @finding.save!
          if session[:bookmarklet] then
            session[:bookmarket] = nil
            return redirect_to(@image.src)
          else
            flash[:success] = "saved!"
            return redirect_to(root_url)
          end
        end
      rescue => problem
        logger.debug(problem)
      end
    end
  end
end
