class QuoteProductsController < ApplicationController
  before_action { authorize QuoteProduct }
  before_action :ensure_quote_editable, only: [:new, :create, :update, :destroy]

  def new
    populate_new
  end

  def create
    populate_new new_params
    if @quote_product.save
      redirect_to @quote, notice: t(:notice_added, item: Quote.model_name.human)
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    populate_edit
    if @quote_product.update new_params
      redirect_to @quote, notice: t(:notice_updated, item: @quote_product.product.name)
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    populate_edit
    if @quote_product.destroy
      redirect_to @quote, notice: t(:notice_removed, item: Product.model_name.human)
    else
      redirect_to @quote, alert: t(:alert_not_removed, item: Product.model_name.human)
    end
  end

  private

  def new_params
    params.require(:quote_product).permit(:id, :product_id, :price, :quantity)
  end

  def populate_new(fill = nil)
    @quote_product = fill ? QuoteProduct.new(fill) : QuoteProduct.new(quantity: 1)
    @quote = Quote.find(params[:quote_id])
    @quote_product.quote = @quote
  end

  def populate_edit
    @quote_product = QuoteProduct.find(params[:id])
    @quote = Quote.find(params[:quote_id])
    @quote_product.quote = @quote
  end

  def ensure_quote_editable
    quote = Quote.find(params[:quote_id])
    return if quote.editable?
    redirect_to quote, alert: t(:notice_quote_locked)
  end
end
