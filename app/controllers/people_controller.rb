#

     #response.add_extension_arg('sreg','required','email,nickname') # <== here...
class PeopleController < ApplicationController

  def new
    # TODO: show a form requesting the user's OpenID
  end

  def create
    # begin the OpenID verification process
    openid_url = params[:openid_url]
    response = openid_consumer.begin openid_url
    if response then
     sreg = OpenID::SReg::Request.new(["nickname", "email"])
     response.add_extension(sreg)
     redirect_url = response.redirect_url(root_url, complete_person_url)
     redirect_to redirect_url
     return
    end
    flash[:error] = "Couldn't find an OpenID for that URL"
    render :action => :new
  end

  def complete
    # omplete the OpenID verification process
    response = openid_consumer.complete(params.select { |k,v| k.include?("openid") }, complete_person_url)
    if response.status == :success then
      session[:identity_url] = response.identity_url
      sreg = ::OpenID::SReg::Response.from_success_response(response)
      person = Person.find(:first, :conditions => ["identity_url = ?", session[:identity_url]])
      person ||= Person.new
      person.identity_url = session[:identity_url]
      person.email = sreg["email"]
      person.nickname = sreg["nickname"]
      person.save!
      redirect_to root_url
      return
    end
    flash[:error] = 'Could not log on with your OpenID'
    redirect_to(new_person_url)
  end

  protected

    def openid_consumer
      @openid_consumer ||= OpenID::Consumer.new(session, OpenID::Store::Filesystem.new("#{RAILS_ROOT}/tmp/openid"))
    end

end
