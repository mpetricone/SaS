class QuoteLaborsController < ApplicationController
  before_action { authorize QuoteLabor }
  before_action :ensure_quote_editable, only: [:new, :create, :edit, :update, :destroy]

  def new
    populate_new
  end

  def create
    populate_new new_params
    if @quote_labor.save
      redirect_to @quote, notice: t(:notice_added, item: QuoteLabor.model_name.human)
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    populate_edit
  end

  def update
    populate_edit
    if @quote_labor.update new_params
      redirect_to @quote, notice: t(:notice_updated, item: QuoteLabor.model_name.human)
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    populate_edit
    if @quote_labor.destroy
      redirect_to @quote, notice: t(:notice_removed, item: QuoteLabor.model_name.human)
    else
      redirect_to @quote, alert: t(:alert_not_removed, item: QuoteLabor.model_name.human)
    end
  end

  private

  def new_params
    params.require(:quote_labor).permit(:id, :rate_id, :description, :billing, :amount, :estimated_hours)
  end

  def populate_new(fill = nil)
    @quote_labor = fill ? QuoteLabor.new(fill) : QuoteLabor.new(billing: :fixed)
    @quote = Quote.find(params[:quote_id])
    @quote_labor.quote = @quote
  end

  def populate_edit
    @quote_labor = QuoteLabor.find(params[:id])
    @quote = Quote.find(params[:quote_id])
    @quote_labor.quote = @quote
  end

  def ensure_quote_editable
    quote = Quote.find(params[:quote_id])
    return if quote.editable?
    redirect_to quote, alert: t(:notice_quote_locked)
  end
end
