#

class FindingsController < ApplicationController
  before_filter :require_person, :except => [:tagged]
  def tagged
    @tag = params[:id]
    flash[:notice] = "You must supply a tag" and return redirect_to(root_url) if @tag.blank?
    @findings = Finding.find_tagged_with(@tag)
    respond_to { |format|
      format.html
      format.rss
    }
  end
  def update
    if request.post? then
      begin
        Finding.transaction do
          @finding = Finding.find(params[:id])
          @finding.tag_list = params[:finding][:tag_list]
          @finding.save!
          return redirect_to(findings_url)
        end
      rescue => problem
        raise problem
      end
    end
  end
  def new
    @disable_urchin = true
    session[:bookmarklet] ||= params[:bookmarklet]
    @image = Image.find_by_src(params[:image][:src])
    @image ||= Image.new
    @image.src = params[:image][:src] if @image.src.blank?
    @image.title = params[:image][:title] if @image.title.blank?
    @finding = Finding.find_by_person_id_and_image_id(current_person, @image)
    @finding ||= Finding.new
    #maybe? @image.title = title if image.new_record?
    if request.post? then
      begin
        Finding.transaction do
          @finding.tag_list = params[:finding][:tag_list]
          @finding.person = current_person
          @finding.image = @image
          blob = Fast.fetch(@image.src)
          @image.x_put(blob)
          @image.save!
          @finding.save!
          #ImageSeek.add_image(1, @image.id, "/tmp/#{@image.permalink}_main")
          if session[:bookmarklet] then
            session[:bookmarket] = nil
            return render(:inline => "<script>window.close();</script>")
          else
            flash[:success] = "saved!"
            return redirect_to(root_url)
          end
        end
      rescue => problem
        logger.debug(problem)
        @image.errors.add(:src, "is probably not an image, or not visible")
      end
    end
  end
end
