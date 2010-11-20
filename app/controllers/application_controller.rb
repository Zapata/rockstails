# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  USER_ID, PASSWORD = "cocktail", "french75"

  before_filter :authenticate 

private
   def authenticate
      authenticate_or_request_with_http_basic do |id, password| 
          id == USER_ID && password == PASSWORD
      end
   end


  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
