class PaymentTermsController < ApplicationController
  before_action { authorize PaymentTerm }

  def index
    @payment_terms = PaymentTerm.ordered.page(params[:page])
    respond_to do |f|
      f.html { render :index }
      f.json { render json: @payment_terms }
    end
  end

  def search_by_name
    where_name = "%#{params[:search_name]}%"
    @payment_terms = PaymentTerm.where('name like ? or description like ?', where_name, where_name).ordered
    respond_to do |f|
      f.html {
        @payment_terms = @payment_terms.page(params[:page])
        render :index
      }
      f.json { render json: @payment_terms }
    end
  end

  def show
    @payment_term = PaymentTerm.find params[:id]
  end

  def new
    @payment_term = PaymentTerm.new(active: true)
  end

  def create
    @payment_term = PaymentTerm.new(new_params)
    respond_to do |f|
      if @payment_term.save
        f.html { redirect_to payment_terms_path, notice: t(:notice_added, item: PaymentTerm.model_name.human) }
        f.json { json_success }
      else
        f.html { render :new, status: :unprocessable_content }
        f.json { json_failure @payment_term.errors }
      end
    end
  end

  def edit
    @payment_term = PaymentTerm.find params[:id]
  end

  def update
    @payment_term = PaymentTerm.find params[:id]
    respond_to do |f|
      if @payment_term.update(new_params)
        f.html { redirect_to @payment_term, notice: t(:notice_updated, item: PaymentTerm.model_name.human) }
        f.json { json_success }
      else
        f.html { render :edit, status: :unprocessable_content }
        f.json { json_failure @payment_term.errors }
      end
    end
  end

  def destroy
    @payment_term = PaymentTerm.find params[:id]
    name = @payment_term.name
    respond_to do |f|
      if @payment_term.destroy
        f.html { redirect_to payment_terms_path, notice: t(:notice_removed, item: PaymentTerm.model_name.human) }
        f.json { json_success }
      else
        f.html { redirect_to payment_terms_path, alert: t(:alert_not_removed, item: PaymentTerm.model_name.human) }
        f.json { json_failure @payment_term.errors }
      end
    end
  end

  private

  def new_params
    params.require(:payment_term).permit(:id, :name, :description, :active)
  end
end
