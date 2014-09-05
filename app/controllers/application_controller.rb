class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # 
  # Suggested at https://coderwall.com/p/8z7z3a Might try this:
  # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.json? }
  
  protect_from_forgery with: :null_session
end
