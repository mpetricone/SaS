class OuAddressesController < ApplicationController
  before_action(only: [:show, :index]) { process_permission has_read_permission(:ou_attribute) }
  before_action(only: [:edit, :update]) { process_permission has_write_permission(:ou_attribute) }
  before_action(only: [:new, :create]) { process_permission has_create_permission(:ou_attribute) }
  before_action(only: [:destroy]) { process_permission has_delete_permission(:ou_attribute) }

  def new
    @ouAddress = OuAddress.new
    @ou =  Ou.find params[:ou_id]
    @ouAddress.ou = @ou
    @ouAddress.address = Address.new
  end

  def create
    @ouAddress = OuAddress.new(new_params)
    @ou = Ou.find params[:ou_id]
    @ouAddress.ou = @ou
    respond_to do |f|
      if @ouAddress.save
        f.html { redirect_to @ou, notice: "#{OuAddress.model_name.human} added."}
        f.json { json_success }
      else
        f.html { render :new, status: :unprocessable_entity}
        f.json { json_failure @ouAddress.errors }
      end
    end
  end

  def destroy
    @ouAddress = OuAddress.find params[:id]
    @ou = Ou.find params[:ou_id]
    respond_to do |f|
      if @ouAddress.delete
        f.html { redirect_to @ou, notice: "#{OuAddress.model_name.human} removed."}
        f.json { json_success }
      else
        f.html { redirect_to @ou, alert: "Error removing #{OuAddress.model_name.human}." }
        f.json { json_failure }
      end
    end
  end

  def edit
    @ouAddress = OuAddress.find params[:id]
    @ou = Ou.find params[:ou_id]
  end

  def update
    @ouAddress = OuAddress.find params[:id]
    @ou = Ou.find params[:ou_id]
    @ouAddress.ou = @ou
    respond_to do |f|
      if @ouAddress.update update_params
        f.html { redirect_to @ou, {notice: "#{OuAddress.model_name.human} updated."} }
        f.json { json_success }
      else
        f.html {render :edit, status: :unprocessable_entity }
        f.json { json_failure @ouAddress.errors }
      end
    end
  end

  private

  def new_params
    params.require(:ou_address).permit(:id, :ou_id, :address_id, :delivery, :invoice,
                                       address_attributes: [:id, :street1, :street2, :city, :postal_code, :state, :country, :status])
  end

  def update_params
    params.require(:ou_address).permit(:id, :ou_id, :address_id, :delivery, :invoice,
                                       address_attributes: [:id, :street1, :street2, :city, :postal_code, :state, :country, :status])
  end

end

