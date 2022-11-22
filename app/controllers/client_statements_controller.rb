class ClientStatementsController < ApplicationController
  before_action(only: [:show, :index, :search_by_name]) { process_permission has_read_permission(:client) }
  before_action(only: [:edit, :update]) { process_permission has_write_permission(:client) }
  before_action(only: [:new, :create]) { process_permission has_create_permission(:client) }
  before_action(only: [:destroy ]) { process_permission has_delete_permission(:client) }

  def index
    @client = Client.find params[:client_id]
  end

  def generate
    @client = Client.find params[:client_id]
    @ar = @client.accounts_receivable(params[:start_date], params[:end_date])
    respond_to do |f|
      if (@ar==[])
        f.js { render 'cs_error' }
        f.js { render json: @ar }
      else
        f.js { render }
        f.html { render :generate }
        f.json { render json: @ar }
      end
    end
  end

end
