class StandingsController < ApplicationController
	before_action :set_standing, only: [:show, :edit, :update, :destroy]
	before_action(only: [ :index, :show, :search_by_name]) { process_permission has_read_permission(:standing) }
	before_action(only: [ :edit, :update]) { process_permission has_write_permission(:standing) }
	before_action(only: [ :new, :create]) { process_permission has_create_permission(:standing) }
	before_action(only: [ :destroy]) { process_permission has_delete_permission(:standing) }

	# GET /standings
	# GET /standings.json
	def index
		respond_to do |f|
			f.html {
				@standings = Standing.page(params[:page])
				render :index
			}
			f.json {
				@standings = Standing.all
				render json: @standings
			}
		end

	end

	def search_by_name
		@standings = Standing.where('name like ?', "%#{params[:search_name]}%")

		respond_to do |f|
			f.html {
				@standings = @standings.page params[:page]
				render :index
			}
			f.json { render json: @standings }
		end

	end

	# GET /standings/1
	# GET /standings/1.json
	def show
	end

	# GET /standings/new
	def new
		@standing = Standing.new
	end

	# GET /standings/1/edit
	def edit
	end

	# POST /standings
	# POST /standings.json
	def create
		@standing = Standing.new(standing_params)

		respond_to do |f|
			if @standing.save
				f.html { redirect_to standings_path, notice: 'Standing was successfully created.' }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity }
				f.json { json_failure @standing.errors }
			end

		end

	end

	# PATCH/PUT /standings/1
	# PATCH/PUT /standings/1.json
	def update
		respond_to do |f|
			if @standing.update(standing_params)
				f.html { redirect_to standings_path, notice: 'Standing was successfully updated.' }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_entity }
				f.json { json_failure @standing.errors }
			end

		end

	end

	# DELETE /standings/1
	# DELETE /standings/1.json
	def destroy
		@standing.destroy
		respond_to do |f|
			f.html { redirect_to standings_url, notice: 'Standing was successfully destroyed.' }
			f.json { json_success }
		end

	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_standing
		@standing = Standing.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def standing_params
		params.require(:standing).permit(:name)
	end
end
