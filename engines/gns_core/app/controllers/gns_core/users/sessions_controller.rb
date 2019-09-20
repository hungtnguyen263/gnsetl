module GnsCore
  class Users::SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]
    layout :set_layout
    
    def new
			self.resource = resource_class.new(sign_in_params)
			clean_up_passwords(resource)
			yield resource if block_given?
			respond_with(resource, serialize_options(resource))
		end

		private
			def set_layout
				"gns_core/backend/login"
			end
  
    # GET /resource/sign_in
    # def new
    #   super
    # end
  
    # POST /resource/sign_in
    # def create
    #   super
    # end
  
    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end
  
    # protected
  
    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end
end
