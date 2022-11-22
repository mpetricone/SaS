class ProductNotesController < ApplicationController
	before_action(only: [:show, :index]) { process_permission has_read_permission(:product_attribute) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:product_attribute) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:product_attribute) }
	before_action(only: [:destroy]) { process_permission has_delete_permission(:product_attribute) }
	def new
		populate_new
	end

	def create
		populate_new new_params

		respond_to do |f|
			if @product_note.save
				f.html { redirect_to @product, notice: "#{ProductNote.model_name.human} #{@product_note.title} added." }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity }
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
				f.html { redirect_to @product, notice: "#{ProductNote.model_name.human} #{@product_note.title} updated." }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_entity }
				f.json { json_failure @product_note.errors }
			end

		end

	end

	def destroy
		populate_edit

		respond_to do |f|
			if @product_note.destroy
				f.html { redirect_to @product, notice: "#{ProductNote.model_name.human} removed." }
				f.json { json_success }
			else
				f.html { redirect_to @product, alert: "Error removing #{ProductNote.model_name.human} #{@product_note.title}." }
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
