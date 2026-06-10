class ProductNotesController < ApplicationController
  before_action { authorize ProductNote }
	def new
		populate_new
	end

	def create
		populate_new new_params

		respond_to do |f|
			if @product_note.save
				f.html { redirect_to @product, notice: t(:notice_added, item: ProductNote.model_name.human) }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_content }
				f.json { json_failure @product_note.errors }
			end

		end

	end

	def edit
		populate_edit
	end

	def update
		populate_edit

		respond_to do |f|
			if @product_note.update new_params
				f.html { redirect_to @product, notice: t(:notice_updated, item: ProductNote.model_name.human) }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_content }
				f.json { json_failure @product_note.errors }
			end

		end

	end

	def destroy
		populate_edit

		respond_to do |f|
			if @product_note.destroy
				f.html { redirect_to @product, notice: t(:notice_removed, item: ProductNote.model_name.human) }
				f.json { json_success }
			else
				f.html { redirect_to @product, alert: t(:alert_not_removed, item: ProductNote.model_name.human) }
				f.json { json_failure }
			end

		end

	end

	private

	def new_params
		params.require(:product_note).permit(:id, :product_id, :title, :note)
	end

	def populate_new fill = nil
		if fill
			@product_note = ProductNote.new fill
		else
			@product_note = ProductNote.new
		end

		@product = Product.find params[:product_id];
		@product_note.product = @product
	end

	def populate_edit
		@product_note = ProductNote.find params[:id]
		@product = Product.find params[:product_id]
		@product_note.product = @product
	end
end
