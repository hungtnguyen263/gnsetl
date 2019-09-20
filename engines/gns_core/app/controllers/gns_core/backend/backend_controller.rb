module GnsCore::Backend
	class BackendController < GnsCore::ApplicationController
    layout :set_layout
    before_action :set_locale
    before_action :set_view
    before_action :authenticate_user!
    
    rescue_from CanCan::AccessDenied do |exception|
			render :file => "gns_core/static/403.html", :status => 403, :layout => false
		end
    
    def set_locale
			I18n.locale = params[:locale] || I18n.default_locale
		end

		def default_url_options
			{ locale: I18n.locale }
		end
    
    private
			def set_layout
				"gns_ux/backend/index"
			end
			
			def set_view
				session[:current_view] = "backend"
			end
  end
end