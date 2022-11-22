class AddressDistributersController < ApplicationController
  before_action(only: [:show, :index]) { process_permission has_read_permission(:distributer_attribute) }
  before_action(only: [:edit, :update]) { process_permission has_write_permission(:distributer_attribute) }
  before_action(only: [:new, :create]) { process_permission has_create_permission(:distributer_attribute) }
  before_action(only: [:destroy]) { process_permission has_delete_permission(:distributer_attribute) }

  def new
    populate_new
  end

  def create
    populate_new new_params

    respond_to do |f|
      if @address_distributer.save
        f.html { redirect_to @distributer, notice: "#{AddressDistributer.model_name.human} added." }
        f.json { json_success }
      else
        f.html { render :new, status: :unprocessable_entity }
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
        f.html { redirect_to @distributer, notice: "Updated #{AddressDistributer.model_name.human}." }
        f.json { json_success }
      else
        f.html { render :edit, status: :unprocessable_entity }
        f.json { json_failure @address_distributer.errors }
      end

    end

  end

  def destroy
    populate_edit

    respond_to do |f|
      if @address_distributer.delete
        f.html { redirect_to @distributer, notice: "Removed #{AddressDistributer.model_name.human}." }
        f.json { json_success }
      else
        f.html { render :show, alert: "Deletion failed." }
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
