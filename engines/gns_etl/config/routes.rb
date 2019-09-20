GnsEtl::Engine.routes.draw do
    scope "(:locale)", locale: /en|vi/ do
        namespace :backend, module: "backend", path: "etl" do
            resources :data_transfers do
                collection do
                    post 'list'
                end
            end
            resources :schedules do
                collection do
                    post 'list'
                    put 'start'
                    put 'stop'
                end
            end
        end
    end
end
