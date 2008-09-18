# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'a047736fbed40c89c719438ff6566708'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  before_filter :find_person

  def find_person
    redirect_to new_person_url unless current_person
  end

  def current_person
    if session[:identity_url] then
      @current_person = Person.find_by_identity_url(session[:identity_url])
    else
      false
    end
  end
end
