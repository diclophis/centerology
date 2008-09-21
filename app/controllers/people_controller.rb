#

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
    #response = openid_consumer.complete(params.select { |k,v| k.include?("openid") }, complete_person_url)
    openid_params = params.dup
    openid_params.delete(:controller)
    openid_params.delete(:action)
    response = openid_consumer.complete(openid_params, complete_person_url)
    if response.status == :success then
      session[:identity_url] = response.identity_url
      sreg = ::OpenID::SReg::Response.from_success_response(response)
      @person = Person.find(:first, :conditions => ["identity_url = ?", session[:identity_url]])
      @person ||= Person.new
      @person.identity_url = session[:identity_url]
      @person.email = sreg["email"]
      @person.nickname = sreg["nickname"]
      begin
        @person.save!
        redirect_to root_url
        return
      rescue => problem
      end
    end
logger.debug(response.inspect)
    flash[:error] = 'Could not log on with your OpenID'
    render(:action => :new)
  end

  protected

    def openid_consumer
      @openid_consumer ||= OpenID::Consumer.new(session, OpenID::Store::Filesystem.new("#{RAILS_ROOT}/tmp/openid"))
    end

end
