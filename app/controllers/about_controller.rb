class AboutController < ApplicationController
  def index
    respond_to do |f|
      f.html { render :index }
      f.json { render json: {} }
    end
  end
end
