#

class WelcomeController < ApplicationController
  def index
    @recent_images = Image.paginate(
      :per_page => current_per_page,
      :page => current_page, 
      #:select => "images.*, count(*) as popularity, DATEDIFF(NOW(), findings.created_at) as newness",
      :select => "images.*, count(*) as popularity, MAX(findings.created_at) as newness",
      #:joins => "JOIN findings ON (findings.image_id = images.id AND DATEDIFF(NOW(), findings.created_at) < 1)",
      :joins => "JOIN findings ON (findings.image_id = images.id)",
      :group => "findings.image_id",
      :order => "newness DESC, popularity DESC, findings.created_at DESC"
    )
    @top_people = Person.paginate(
      :per_page => 10,
      :page => 1,
      :select => "people.*, count(*) as activity",
      :joins => "JOIN findings ON findings.person_id = people.id",
      :group => "findings.person_id",
      :order => "activity DESC"
    )
    @recent_people = Person.paginate(
      :per_page => 10,
      :page => 1,
      :joins => "JOIN findings ON findings.person_id = people.id",
      :group => "findings.person_id",
      :order => "findings.created_at DESC"
    )
  end
  def feed
    @feeder = Person.find_by_nickname(params[:nickname])
    if params[:screensaver] then
      @images = @feeder.images
    else
      @images = @feeder.last_three_images
    end
    respond_to { |format|
      format.html
      format.rss
    }
  end
  def findings
  end
  def philosophy
  end
  def image
    redirect_to(root_url) unless Image.exists?(:permalink => params[:permalink])
    @image = Image.find_by_permalink(params[:permalink])
  end
  def similarities
    redirect_to(root_url) unless current_person
    redirect_to(root_url) unless Image.exists?(:permalink => params[:permalink])
    @image = Image.find_by_permalink(params[:permalink])
  end
  def bookmarklet
    new_findings_url = url_for({:controller => :findings, :action => :new})
    @js = render_to_string(:inline => "
    window.open('#{new_findings_url}?bookmarklet=1&finding[tag_list]=&image[src]='+encodeURIComponent(window.location)+'&image[title]='+encodeURIComponent(document.title),'_blank');
    ").gsub!("\n", "")
    @js = "javascript:(function(){#{@js}})()"
  end
  def cloud
  end
  def random
    #sleep 5
    redirect_to(Image.find(:first, :offset => (Image.count * rand).to_i).thumb_permalink)
  end
  def plist_of_images_to_rate
    #plist = {'a'  => 'b', 'c' => 'd', 'e' => {'f' => 'g', 'h' => {'i' => 'j'}}}.to_plist
    #images = Images.
    render(:text => plist)
  end
end
