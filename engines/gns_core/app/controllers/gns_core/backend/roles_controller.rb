module GnsCore
  module Backend
    class RolesController < GnsCore::Backend::BackendController
      before_action :set_role, only: [:edit, :update, :destroy,
                                      :roles_permissions, :update_permissions,
                                      :activate, :deactivate]
  
      # GET /roles
      def index
      end
      
      # POST /roles/list
      def list
        @roles = Role.search(params).paginate(:page => params[:page], :per_page => params[:per_page])
        
        render layout: nil
      end
  
      # GET /roles/1
      def roles_permissions
        authorize! :set_permissions, @role
      end
      
      def update_permissions
        authorize! :set_permissions, @role
        
        if params[:permissions].present?
          params[:permissions].each do |p|
            if p[1] == 'true'
              @role.add_permission(p[0])
            else
              @role.remove_permission(p[0])
            end
          end
          
          # Add notification
          current_user.add_notification("gns_core.notification.role.update_permissions", @role)
          
          flash[:success] = 'Role has been updated policies successfully.'
          redirect_to gns_core.backend_roles_path
        end
      end
  
      # GET /roles/new
      def new
        authorize! :create, GnsCore::Role
        
        @role = Role.new
      end
  
      # GET /roles/1/edit
      def edit
        authorize! :update, @role
      end
  
      # POST /roles
      def create
        authorize! :create, GnsCore::Role
        
        @role = Role.new(role_params)
        @role.creator = current_user
  
        if @role.save
          # Add notification
          current_user.add_notification("gns_core.notification.role.created", @role)
          
          flash[:success] = 'Role was successfully created.'
          render json: {
            redirect: gns_core.roles_permissions_backend_roles_path(@role)
          }
        else
          render :new
        end
      end
  
      # PATCH/PUT /roles/1
      def update
        authorize! :update, @role
        
        if @role.update(role_params)
          # Add notification
          current_user.add_notification("gns_core.notification.role.updated", @role)
          
          render json: {
            status: 'success',
            message: 'Role was successfully updated.',
          }
        else
          render :edit
        end
      end
      
      # DELETE /roles/1
      def destroy
        authorize! :delete, @role
        
        # Add notification
        current_user.add_notification("gns_core.notification.role.delete", @role)
        
        if @role.destroy
          render json: {
            status: 'success',
            message: 'The role was successfully destroyed.',
          }
        else
          render json: {
            status: 'warning',
            message: @role.errors.full_messages.to_sentence
          }
        end
      end
      
      # select2 ajax
      def select2
        render json: Role.select2(params)
      end
      
      # ACTIVATE /roles/1
      def activate
        authorize! :activate, @role
        
        @role.activate
        
        # Add notification
        current_user.add_notification("gns_core.notification.role.activate", @role)
        
        render json: {
          status: 'success',
          message: 'Employee was successfully activated.',
        }
      end
      
      # DEACTIVATE /roles/1
      def deactivate
        authorize! :deactivate, @role
        
        @role.deactivate
        
        # Add notification
        current_user.add_notification("gns_core.notification.role.deactivate", @role)
        
        render json: {
          status: 'success',
          message: 'Employee was successfully deactivated.',
        }
      end
  
      private
        # Use callbacks to share common setup or constraints between actions.
        def set_role
          @role = Role.find(params[:id])
        end
  
        # Only allow a trusted parameter "white list" through.
        def role_params
          params.fetch(:role, {}).permit(:name)
        end
    end
  end
end
