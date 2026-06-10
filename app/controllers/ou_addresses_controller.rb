class OuAddressesController < ApplicationController
  before_action { authorize OuAddress }

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
        f.html { redirect_to @ou, notice: t(:notice_added, item: OuAddress.model_name.human)}
        f.json { json_success }
      else
        f.html { render :new, status: :unprocessable_content}
        f.json { json_failure @ouAddress.errors }
      end
    end
  end

  def destroy
    @ouAddress = OuAddress.find params[:id]
    @ou = Ou.find params[:ou_id]
    respond_to do |f|
      if @ouAddress.delete
        f.html { redirect_to @ou, notice: t(:notice_removed, item: OuAddress.model_name.human)}
        f.json { json_success }
      else
        f.html { redirect_to @ou, alert: t(:alert_not_removed, item: OuAddress.model_name.human) }
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
        f.html { redirect_to @ou, {notice: t(:notice_updated, item: OuAddress.model_name.human)} }
        f.json { json_success }
      else
        f.html {render :edit, status: :unprocessable_content }
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

