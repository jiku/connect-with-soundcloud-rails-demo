ConnectWithSoundCloudDemo::Application.routes.draw do
  root :to => "welcome#index"

  get '/you',           :to => 'welcome#show',    :as => :you
  get '/you/update',    :to => 'welcome#update',  :as => :you_update

  get '/soundcloud/connect',    :to => 'soundcloud#connect',    :as => :soundcloud_connect
  get '/soundcloud/connected',  :to => 'soundcloud#connected',  :as => :soundcloud_connected
  get '/soundcloud/disconnect', :to => 'soundcloud#disconnect', :as => :soundcloud_disconnect

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
