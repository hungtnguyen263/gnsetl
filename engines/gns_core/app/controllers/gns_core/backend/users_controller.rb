module GnsCore
  module Backend
    class UsersController < GnsCore::Backend::BackendController
      before_action :set_user, only: [:show, :edit, :update]
  
      # GET /users
      def index
      end
      
      # POST /users/list
      def list
        @users = User.search(params).paginate(:page => params[:page], :per_page => params[:per_page])
        
        render layout: nil
      end
  
      # GET /users/1
      def show
        authorize! :read, @user
      end
  
      # GET /users/new
      def new
        authorize! :create, GnsCore::User
        
        @user = User.new
        @user.employee_id = params[:employee_id].present? ? params[:employee_id] : nil
      end
  
      # GET /users/1/edit
      def edit
        authorize! :update, @user
      end
  
      # POST /users
      def create
        authorize! :create, GnsCore::User
        
        @user = User.new(user_params)
        
        @user.creator = current_user
  
        if @user.save
          # Add notification
          current_user.add_notification("gns_core.notification.user.created", @user.employee)
          
          render json: {
            status: 'success',
            message: 'User was successfully created.',
          }
        else
          render :new
        end
      end
  
      # PATCH/PUT /users/1
      def update
        authorize! :update, @user
        
        if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
          params[:user].delete(:password)
          params[:user].delete(:password_confirmation)
        end
        
        if @user.update(user_params)
          # Add notification
          current_user.add_notification("gns_core.notification.user.updated", @user.employee)
          
          render json: {
            status: 'success',
            message: 'User was successfully updated.',
          }
        else
          render :edit
        end
      end
      
      def select2
        render json: User.select2(params)
      end
  
      private
        # Use callbacks to share common setup or constraints between actions.
        def set_user
          @user = User.find(params[:id])
        end
  
        # Only allow a trusted parameter "white list" through.
        def user_params
          params.fetch(:user, {}).permit(:avatar, :email, :password, :employee_id,
                                         role_ids: [])
        end
    end
  end
end
