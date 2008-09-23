#

class PeopleController < ApplicationController
  def login
    if params["openid.mode"] then
      response = openid_consumer.complete(openid_params, url_for(:login))
      pending_person.errors.add(:identity_url, "OpenID Failure") and return render unless response.status == :success
      flash[:notice] = "Please register first..." and return redirect_to({:action => :register, :person => pending_person.attributes}) unless Person.exists?(:identity_url => response.identity_url)
      return redirect_to(remembered_params)
    elsif request.post? then
      begin
        response = openid_consumer.begin(params[:person][:identity_url])
        redirect_url = response.redirect_url(root_url, url_for(:login))
        return redirect_to redirect_url
      rescue => problem
        @person.identity_url = params[:person][:identity_url]
        @person.errors.add(:identity_url, problem)
      end
    end
  end
  def register
    if params["openid.mode"] then
      response = openid_consumer.complete(openid_params, url_for(:register))
      pending_person.errors.add(:identity_url, "OpenID Failure") and return render unless response.status == :success
      raise pending_person.inspect
    elsif request.post? then
      if pending_person.valid? then
        begin
          response = openid_consumer.begin(params[:person][:identity_url])
          return login if Person.exists?(:identity_url => params[:person][:identity_url])
          if response then
            remember_pending_person
            redirect_url = response.redirect_url(root_url, url_for(:register))
            redirect_to redirect_url
            return
          end
        rescue => problem
          @person.errors.add(:identity_url, problem)
        end
      end
    else
      pending_person
    end
  end
  protected
    def pending_person
      unless @person
        @person = session[:pending_person] || Person.new
        if params[:person] then
          @person.identity_url = params[:person][:identity_url]
          @person.nickname = params[:person][:nickname]
          @person.email = params[:person][:email]
        end
        @person.identity_url = params["openid.identity"] if @person.identity_url.blank?
      end
      @person
    end
    def remember_pending_person
      session[:pending_person] = pending_person
    end
    def openid_params
      cleaned = params.dup
      cleaned.delete(:controller)
      cleaned.delete(:action)
      cleaned
    end
    def openid_consumer
      @openid_consumer ||= OpenID::Consumer.new(session, OpenID::Store::Filesystem.new("#{RAILS_ROOT}/tmp/openid"))
    end
end
