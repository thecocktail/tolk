ActionController::Routing::Routes.draw do |map|
  map.namespace('tolk', :path_prefix=>"admin/tolk") do |tolk|
    tolk.root :controller => 'locales', :action=>:index
    tolk.resources :locales, :member => {:all => :get, :updated => :get}, :collection => { :delete => :delete }
    tolk.resource :search
  end
end
