class LogsController < ApplicationController
  before_action { authorize Log }

  def show
    @log = Log.find(params[:id])
  end

  def ack
    @log = Log.find(params[:id])
    @log.ack_at = Time.now
    respond_to do |f|
      if @log.save
        f.html {
          redirect_to @log, notice: t(:notice_updated, item: Log.model_name.human) }
      else
        f.html { render :show, status: :unprocessable_content }
      end
    end
  end


  def index
    respond_to do |f|
      f.html {
        @logs = Log.order(event_at: :desc).page(params[:page])
        render :index
      }
    end
  end

  private

  def update_params
    params.require(:log).permit(:ack_at)
  end
end

