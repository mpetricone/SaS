class AddressDistributersController < ApplicationController
  before_action { authorize AddressDistributer }

  def new
    populate_new
  end

  def create
    populate_new new_params

    respond_to do |f|
      if @address_distributer.save
        f.html { redirect_to @distributer, notice: t(:notice_added, item: AddressDistributer.model_name.human) }
        f.json { json_success }
      else
        f.html { render :new, status: :unprocessable_content }
        f.json { json_failure @address_distributer.errors }
      end

    end

  end

  def edit
    populate_edit
  end

  def update
    populate_edit

    respond_to do |f|
      if @address_distributer.update new_params
        f.html { redirect_to @distributer, notice: t(:notice_updated, item: AddressDistributer.model_name.human) }
        f.json { json_success }
      else
        f.html { render :edit, status: :unprocessable_content }
        f.json { json_failure @address_distributer.errors }
      end

    end

  end

  def destroy
    populate_edit

    respond_to do |f|
      if @address_distributer.delete
        f.html { redirect_to @distributer, notice: t(:notice_removed, item: AddressDistributer.model_name.human) }
        f.json { json_success }
      else
        f.html { render :show, alert: t(:alert_not_removed, item: AddressDistributer.model_name.human) }
        f.json { json_failure @address_distributer.errors }
      end

    end

  end

  private

  def new_params
    params.require(:address_distributer).permit(:id, :address_id, :distriuter_id, :delivery, :invoice,
                                                address_attributes: [:id, :street1, :street2, :city, :postal_code, :state, :country, :status])
  end

  def populate_new fill = nil
    if (fill)
      @address_distributer = AddressDistributer.new fill
    else
      @address_distributer = AddressDistributer.new
      @address_distributer.address = Address.new
    end

    @distributer = Distributer.find params[:distributer_id]
    @address_distributer.distributer = @distributer
  end

  def populate_edit
    @address_distributer = AddressDistributer.find params[:id]
    @distributer = Distributer.find params[:distributer_id]
    @address_distributer.distributer = @distributer
  end
end
