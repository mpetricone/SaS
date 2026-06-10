class ClientStatementsController < ApplicationController
  before_action { authorize :client_statement }

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
