class OusController < ApplicationController
  before_action(only: [:index, :show, :search_by_name]) { process_permission has_read_permission(:ou) }
  before_action(only: [:edit, :update]) {process_permission has_write_permission(:ou) }
  before_action(only: [:new, :create]) { process_permission has_create_permission(:ou) }
  before_action(only: [:destroy]) { process_permission has_delete_permission(:ou) }

  def index
    respond_to do |f|
      f.html {
        @ous = Ou.page(params[:page])
        render :index
      }
      f.json {
        @ous = Ou.all
        render json: @ou
      }
    end
  end

	def search_by_name
		@ous = Ou.where('name like ?', "%#{params[:search_name]}%")

		respond_to do |f|
			f.html {
				@ous = @ous.page params[:page]
				render :index
			}
			f.json { render json: @ous }
		end
	end

  def new
    @ou = Ou.new
    @ou.ou_phones.build
    @ou.ou_emails.build
    @ou.ou_addresses.build(address: Address.new)
    @ou.roots.build
  end

  def create
    @ou = Ou.new(ou_params)
    if  (params[:ou].has_key? :roots_attributes) && (params[:ou][:roots_attributes]["0"][:root_id]!="")
      @ou_parent = Ou.find(params[:ou][:roots_attributes]["0"][:root_id])
      @ou.root = @ou_parent
    end
    respond_to do |f|
      if (@ou.save)
        f.html { redirect_to @ou, flash: { notice: "Record created"} }
        f.json { json_success }
      else
        f.html { render :new, status: :unprocessable_entity}
        f.json { json_failure @ou.errors }
      end
    end
  end

  def show
    @ou = Ou.find(params[:id])
    respond_to do |f|
      f.html { render :show }
      f.json { render json: {
        ou: @ou,
        ou_addresses: @ou.ou_addresses,
        addresses: @ou.addresses,
        ou_phones: @ou.ou_phones,
        ou_emails: @ou.ou_emails
      } }
    end
  end

  def edit
    @ou = Ou.find(params[:id])

  end

  def update
    @ou = Ou.find(params[:id])

    respond_to do |f|

      if @ou.update(ou_params)
        f.html { redirect_to @ou }
        f.json { json_success }
      else
        f.html { render :edit, status: :unprocessable_entity}
        f.json { json_failure @ou.errors }
      end
    end
  end

  def destroy
    @ou = Ou.find(params[:id])
    @ou.destroy

    respond_to do |format|
      format.html { redirect_to ous_path, flash: { notice: "Record Destroyed" } }
      format.json { json_success }
    end
  end

  private

  def ou_params
    params.require(:ou).permit( :id, :name, :description, :root_id, :tax_id,
                               roots_attributes: [:id, :root_id],
                               ou_phones_attributes: [:id, :number],
                               ou_emails_attributes: [:id, :address],
                               ou_addresses_attributes: [:id,:ou_id, :address_id,:delivery, :invoice,
                                                         address_attributes: [:id, :street1, :street2, :city, :postal_code, :state, :country, :status]])

  end

end
