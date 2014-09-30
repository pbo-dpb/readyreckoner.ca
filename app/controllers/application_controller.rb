class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  # If the query string sets the locale, updates the session's locale. Sets the
  # current locale to the session's locale. If the session's locale is not set,
  # it sets the current locale to the default locale and renders a splash page.
  def set_locale
    if params[:locale].present? && I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
    end

    I18n.locale = session[:locale] || I18n.default_locale

    unless session[:locale]
      render 'pages/switcher'
    end
  end
end
