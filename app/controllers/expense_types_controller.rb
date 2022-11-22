class ExpenseTypesController < ApplicationController
	before_action :set_expense_type, only: [:show, :edit, :update, :destroy]
	before_action(only: [:show, :index, :search_by_name]) { process_permission has_read_permission(:expense_attribute) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:expense_attribute) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:expense_attribute) }
	before_action(only: [:delete]) { process_permission has_delete_permission(:expense_attribute) }

	# GET /expense_types
	# GET /expense_types.json
	def index
		respond_to do |f|
			f.html {
				@expense_types = ExpenseType.page(params[:page])
				render :index
			}
			f.json {
				@expense_types = ExpenseType.all
				render json: @expense_types
			}
		end

	end

	def search_by_name
		@expense_types = ExpenseType.where('name like ?', "%#{params[:search_name]}%")

		respond_to do |f|
			f.html {
				@expense_types = @expense_types.page params[:page]
				render :index
			}
			f.json { render json: @expense_types }
		end

	end

	# GET /expense_types/1
	# GET /expense_types/1.json
	def show
	end

	# GET /expense_types/new
	def new
		@expense_type = ExpenseType.new
	end

	# GET /expense_types/1/edit
	def edit
	end

	# POST /expense_types
	# POST /expense_types.json
	def create
		@expense_type = ExpenseType.new(expense_type_params)

		respond_to do |f|
			if @expense_type.save
				f.html { redirect_to expense_types_path, notice: 'Expense type was successfully created.' }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity }
				f.json { json_failure @expense_type.errors }
			end

		end

	end

	# PATCH/PUT /expense_types/1
	# PATCH/PUT /expense_types/1.json
	def update
		respond_to do |f|
			if @expense_type.update(expense_type_params)
				f.html { redirect_to @expense_type, notice: 'Expense type was successfully updated.' }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_entity }
				f.json { json_failure @expense_type.errors }
			end

		end

	end

	# DELETE /expense_types/1
	# DELETE /expense_types/1.json
  # Disabled, deleting this record type is application breaking
	def destroy
    #Simply do not destroy, and continue
		#@expense_type.destroy
		respond_to do |f|
      #Still display a note.
      f.html { redirect_to expense_types_url, notice: 'Expense Types cannot be destroyed.'}
      f.json { json_success } #may be altered soon, not currently used.
		end

	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_expense_type
		@expense_type = ExpenseType.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def expense_type_params
		params.require(:expense_type).permit(:id, :name, :description)
	end
end
