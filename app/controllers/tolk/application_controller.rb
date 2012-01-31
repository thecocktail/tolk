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

   def authenticate
     self.authenticator.bind(self).call if self.authenticator && self.authenticator.respond_to?(:call)
   end

   def ensure_no_primary_locale
     redirect_to tolk_locales_path if @locale.primary?
   end
   
   def logged_in?
     !!current_user
   end

   
 end
end