class ProductsController < ApplicationController
  before_action { authorize Product }

	def index
		respond_to do |f|
			f.html {
				@products = Product.page(params[:page])
				render :index
			}
			f.json { render json: Product.all }
		end

	end

	def show
		@product = Product.find params[:id]
		respond_to do |f|
			f.html { render :show }
			f.json { render json: {
				product: @product,
				distributer_products: @product.distributer_products,
				distributers: @product.distributers
			} }
		end

	end

	def new
		@product = Product.new
		@product.distributer_products.build
	end

	def search_by_name
		@products = Product.where('name like ?', "%#{params[:search_name]}%")

		respond_to do |f|
			f.html {
				@products = @products.page params[:page]
				render :index
			}
			f.json { render json: @products }
		end

	end

	def create
		@product = Product.new new_params

		respond_to do |f|
			if @product.save
				f.html { redirect_to @product, notice: t(:notice_added, item: Product.model_name.human) }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_content }
				f.json { json_failure @product.errors }
			end

		end

	end

	def edit
		@product = Product.find params[:id]
	end

	def update
		@product = Product.find params[:id]

		respond_to do |f|
			if (@product.update new_params)
				f.html { redirect_to @product, notice: t(:notice_updated, item: Product.model_name.human) }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_content}
				f.json { json_failure @product.errors }
			end

		end

	end

	def destroy
		@product = Product.find params[:id]

		respond_to do |f|
			if (@product.destroy)
				f.html { redirect_to products_path, notice: t(:notice_removed, item: Product.model_name.human) }
				f.json { json_success }
			else
				f.html { redirect_to products_path, alert: t(:alert_not_removed, item: Product.model_name.human) }
				f.json { json_failure @product.errors }
			end

		end

	end

	private
	def new_params
		params.require(:product).permit(:id, :base_cost, :name, :description, :category, :item_number, :sku, :manufacturer,
																		distributer_products_attributes: [:id, :distributer_id, :product_id,:dist_item_number, :current_cost] )
	end
end
