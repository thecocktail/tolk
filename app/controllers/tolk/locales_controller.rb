module Tolk
  class LocalesController < Tolk::ApplicationController
    before_filter :find_locale, :only => [:show, :all, :update, :updated]
    before_filter :ensure_no_primary_locale, :only => [:all, :update, :show, :updated]

    def index
      @locales = Tolk::Locale.secondary_locales
      respond_to do |format|
        format.html {render "/admin/tolk/locales/index", :layout=>"admin"}
      end
    end
  
    def show
      respond_to do |format|
        format.html do
          @phrases = @locale.phrases_without_translation(params[:page])
          render "/admin/tolk/locales/show", :layout=>"admin"
        end
        format.atom { @phrases = @locale.phrases_without_translation(params[:page], :per_page => 50) }
        format.yml { render :text => @locale.to_hash.ya2yaml(:syck_compatible => true) }
      end
    end

    def update
      @locale.translations_attributes = params[:translations]
      @locale.save
      redirect_to request.referrer
    end

    def all
      @phrases = @locale.phrases_with_translation(params[:page])
      respond_to do |format|
        format.html {render "/admin/tolk/locales/all", :layout=>"admin"}
      end
    end

    def updated
      @phrases = @locale.phrases_with_updated_translation(params[:page])
      respond_to do |format|
        format.html {render "/admin/tolk/locales/all", :layout=>"admin"}
      end
    end

    def create
      Tolk::Locale.create!(params[:tolk_locale])
      redirect_to :action => :index
    end
    
    def delete
      # begin
        Tolk::Locale.destroy_all :id=>params[:ids]
      # rescue Exception=>e
        # Rails.logger.info e
      # ensure
        redirect_to :action => :index
      # end
    end

    private

    def find_locale
      
      @locale = Tolk::Locale.find_by_name!(params[:id])
    end
  end
end
