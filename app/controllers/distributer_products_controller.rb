class DistributerProductsController < ApplicationController
	before_action(only: [:show, :index]) { process_permission has_read_permission(:distributer_permission) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:distributer_permission) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:distributer_permission) }
	before_action(only: [:create]) { process_permission has_delete_permission(:distributer_permission) }

	def new
		populate_new
	end

	def create
		populate_new new_params

		respond_to do |f|
			if (@distributer_product.save)
				f.html { redirect_to @product, notice: "#{@product.name} added to #{@distributer_product.distributer.name}." }
				f.json { json_success }
			else
				f.html { redirect_to @product, alert: "Error adding #{@product.name}." }
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
				f.html { redirect_to @product, notice: "#{@product.name} altered succesfully." }
				f.json { json_success }
			else
				f.html { redirect_to @product, alert: "Error editing #{@product.name}." }
				f.json { json_failure @distributer_product.errors }
			end
		end
	end

	def destroy
		populate_edit

		respond_to do |f|
			if @distributer_product.delete
				f.html { redirect_to @product, notice: "#{DistributerProduct.model_name.human} deleted." }
				f.json { json_success }
			else
				f.html { redirect_to @product, alert: "Could not delete #{@product.name}." }
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
