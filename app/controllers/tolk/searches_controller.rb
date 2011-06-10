module Tolk
  class SearchesController < Tolk::ApplicationController
    before_filter :find_locale
  
    def show
      @phrases = @locale.search_phrases(params[:q], params[:scope].to_sym, params[:page])
      respond_to do |format|
        format.html {render "/admin/tolk/searches/show", :layout=>"admin"}
      end
    end

    private

    def find_locale
      uri_locale = CGI.parse(URI.parse(request.fullpath).query)["locale"].to_s
      @locale = Tolk::Locale.find_by_name!(uri_locale) #params[:locale]
    end
  end
end
