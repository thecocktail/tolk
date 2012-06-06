module Tolk
 class ApplicationController < ActionController::Base
   
   include ExceptionNotification::Notifiable
   include NeutrinoFunctions
   
   # helper :application
   
   helper :all
   protect_from_forgery
   
   acts_as_time_machine
   
   cattr_accessor :authenticator
   before_filter :authenticate
   before_filter :set_admin_site
   
   def authenticate
     self.authenticator.bind(self).call if self.authenticator && self.authenticator.respond_to?(:call)
   end

   def set_admin_site
     @admin_site ||= if params[:admin_site]
       site_nicetitle = params[:admin_site]
       site = Site.find_by_nicetitle site_nicetitle
       session[:admin_site] = site.id
       site
     elsif session[:admin_site]
       Site.find session[:admin_site]
     else
       set_site
     end
   end
   def ensure_no_primary_locale
     redirect_to tolk_locales_path if @locale.primary?
   end
   
   def logged_in?
     !!current_user
   end

   
 end
end