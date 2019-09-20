module GnsCore
  module Backend
    class AccountsController < GnsCore::Backend::BackendController
      before_action :set_account, only: [:my_profile, :my_account,
                                         :update_profile, :update_account, :update_password]
  
      # GET /accounts
      def my_profile
        @profile = @account.employee.present? ? @account.employee : nil
      end
      
      # update profile / employee info
      def update_profile
        @profile = @account.employee
        
        if params[:profile].present?
          @profile.assign_attributes(profile_params)
          @profile.save
          redirect_to gns_core.my_profile_backend_accounts_path, flash: {success: 'Profile has been updated successfully.'}
        else
          redirect_to gns_core.my_profile_backend_accounts_path, flash: {error: 'Profile update failed. Please try again!'}
        end
      end
      
      def my_account
      end
      
      # update info / my account
      def update_account
        if params[:account].present?
          if @account.update(avatar: params[:account][:avatar])
            redirect_to gns_core.my_account_backend_accounts_path, flash: {success: 'Avatar was successfully updated.'}
          end
        else
          redirect_to gns_core.my_account_backend_accounts_path, flash: {error: 'Avatar update failed. Please try again'}
        end
      end
      
      # change password / my account
      def update_password
        # check current password is valid
        if params[:account].present? and !@account.valid_password?(params[:account][:current_password])
          redirect_to gns_core.my_account_backend_accounts_path, flash: { error: "Current password incorrectly." }
          return
        end

        if params[:account].present?
          params[:account].delete(:password) if params[:account][:password].blank?
          params[:account].delete(:password_confirmation) if params[:account][:password].blank? and params[:account][:password_confirmation].blank?

          if @account.update_with_password(account_params)
            bypass_sign_in(@account)
            redirect_to gns_core.my_account_backend_accounts_path, flash: { success: "The new password has been successfully changed." }
          else
            if params[:account][:password].nil? or params[:account][:password].length < 6
              redirect_to gns_core.my_account_backend_accounts_path, flash: { error: "New password must contain at least 6 characters." }
            else
              redirect_to gns_core.my_account_backend_accounts_path, flash: { error: "Repeat password does not match." }
            end
          end
        end
      end
  
      private
        # Use callbacks to share common setup or constraints between actions.
        def set_account
          @account = current_user
        end
  
        # Only allow a trusted parameter "white list" through.
        def account_params
          params.fetch(:account, {}).permit(:current_password, :password, :password_confirmation)
        end
        
        def profile_params
          params.fetch(:profile, {}).permit(:phone, :mobile, :email, :birthday, :country_id, :state_id, :district_id, :address)
        end
    end
  end
end
