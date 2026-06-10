class AboutController < ApplicationController
  def skip_pundit? = true

  def index
    respond_to do |f|
      f.html { render :index }
      f.json { render json: {} }
    end
  end
end
