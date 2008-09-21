#

class WelcomeController < ApplicationController
  def index
    @recent_images = Image.paginate(
      :per_page => current_per_page,
      :page => current_page, 
      :select => "images.*, count(*) as popularity",
      :joins => "JOIN findings ON findings.image_id = images.id",
      :group => "findings.image_id",
      :order => "popularity DESC, findings.created_at DESC"
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
  end
  def findings
  end
  def about
  end
  def bookmarklet
    @js = render_to_string(:inline => "
    window.open('http://centerology.risingcode.com/findings/new?bookmarklet=1&image[src]='+encodeURIComponent(window.location)+'&image[title]='+encodeURIComponent(document.title),'_blank');
    ").gsub!("\n", "")
    @js = "javascript:(function(){#{@js}})()"
  end
end
