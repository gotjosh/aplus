# ApplicationController
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_context
  before_action :set_locale

  helper_method :current_user

  def current_user
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      @user = nil
    end
  end

  def current_user=(user)
    session[:user_uname] = user.username
    session[:user_name] = user.name
    session[:user_id] = user.id.to_s
  end

  private

    # Sets the context for the topics menu
    def set_context
      @total_notifications = ShareRequest.where(recipient: session[:user_id]).count.to_i
    end
    
    def authenticate_user!
      redirect_to login_path unless current_user
    end

    def set_locale
      if not session[:user_id].nil?
        user = User.find(session[:user_id])
        I18n.locale = user.locale unless user.nil?
      else
        I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
      end
    end
 end
