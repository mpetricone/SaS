class LogsController < ApplicationController
  before_action(only: [:index, :show]) { process_permission has_read_permission(:auditor)}
  before_action(only: [:ack]) { process_permission has_write_permission(:auditor)}

  def show
    @log = Log.find(params[:id])
  end

  def ack
    @log = Log.find(params[:id])
    @log.ack_at = Time.now
    respond_to do |f|
      if @log.save
        log_success(request, params)
        f.html { 
          redirect_to @log, notice: t(:notice_updated, item: Log.model_name.human) }
      else
        log_failure(request, params)
        f.html { render :show, status: :unprocessable_content }
      end
    end
  end


  def index
    respond_to do |f|
      f.html {
        log_success( request, params)
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

