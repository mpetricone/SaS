class DistributerProductsController < ApplicationController
  before_action { authorize DistributerProduct }

	def new
		populate_new
	end

	def create
		populate_new new_params

		respond_to do |f|
			if (@distributer_product.save)
				f.html { redirect_to @product, notice: t(:notice_added, item: DistributerProduct.model_name.human) }
				f.json { json_success }
			else
				f.html { redirect_to @product, alert: t(:alert_not_added, item: DistributerProduct.model_name.human) }
				f.json { json_failure @distributer_product.errors }
			end
		end
	end

	def edit
		populate_edit
	end

	def update
		populate_edit

		respond_to do |f|
			if @distributer_product.update new_params
				f.html { redirect_to @product, notice: t(:notice_updated, item: DistributerProduct.model_name.human) }
				f.json { json_success }
			else
				f.html { redirect_to @product, alert: t(:alert_not_updated, item: DistributerProduct.model_name.human) }
				f.json { json_failure @distributer_product.errors }
			end
		end
	end

	def destroy
		populate_edit

		respond_to do |f|
			if @distributer_product.delete
				f.html { redirect_to @product, notice: t(:notice_removed, item: DistributerProduct.model_name.human) }
				f.json { json_success }
			else
				f.html { redirect_to @product, alert: t(:alert_not_removed, item: DistributerProduct.model_name.human) }
				f.json { json_failure @distributer_product.errors }
			end
		end
	end
	private

	def new_params
		params.require(:distributer_product).permit(:id, :distributer_id, :product_id, :dist_item_number, :current_cost)
	end

	def populate_new fill = nil
		if fill
			@distributer_product = DistributerProduct.new new_params
		else
			@distributer_product = DistributerProduct.new
		end
		@product = Product.find params[:product_id]
		@distributer_product.product = @product
	end

	def populate_edit
		@distributer_product = DistributerProduct.eager_load(:distributer).find params[:id]
		@product = Product.find params[:product_id]
	end

end
