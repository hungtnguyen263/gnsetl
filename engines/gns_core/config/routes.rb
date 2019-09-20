GnsCore::Engine.routes.draw do
    scope "(:locale)", locale: /en|vi/ do
        devise_for :users,
            class_name: "GnsCore::User",
            module: :devise,
            controllers: {
                sessions: 'gns_core/users/sessions'
            },
            path_names: {
                sign_in: 'login',
                sign_out: 'logout'
            }
        root to: "backend/dashboard#index"
        
        namespace :backend, module: "backend", path: "backend/system" do
            resources :users do
                collection do
                    post 'list'
                    get 'select2'
                end
            end
            resources :roles do
                collection do
                    post 'list'
                    get 'select2'
                    put 'activate'
                    put 'deactivate'
                    get ':id/roles_permissions', to: 'roles#roles_permissions', as: 'roles_permissions'
                    post ':id/update_permissions', to: 'roles#update_permissions', as: 'update_permissions'
                end
            end
            resources :accounts do
                collection do
                    get 'my_profile'
                    post 'update_profile'
                    
                    get 'my_account'
                    post 'update_account'
                    post 'update_password'
                    
                    get 'my_notes'
                end
            end
        end
    end
end
