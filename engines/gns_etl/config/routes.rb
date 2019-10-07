GnsEtl::Engine.routes.draw do
    scope "(:locale)", locale: /en|vi/ do
        namespace :backend, module: "backend", path: "etl" do
            resources :data_transfers do
                collection do
                    post 'list'
                end
            end
            resources :mappings do
                collection do
                    post 'list'
                    get 'select_source_fields'
                    get 'select_destination_fields'
                end
            end
            resources :schedules do
                collection do
                    post 'list'
                    get ':id/logs', to: 'schedules#logs', as: 'logs'
                    post ':id/logs_list', to: 'schedules#logs_list', as: 'logs_list'
                    get 'start'
                    post 'start'
                    
                    put 'stop'
                    put 'load_csv'
                    
                    get 'extract'
                    post 'extract'
                    get 'transfer'
                    post 'transfer'
                end
            end
        end
    end
end
