class OuPhonesController < ApplicationController
  before_action(only: [:show, :index]) { process_permission has_read_permission(:ou_attribute) }
  before_action(only: [:edit, :update]) { process_permission has_write_permission(:ou_attribute) }
  before_action(only: [:new, :create]) { process_permission has_create_permission(:ou_attribute) }
  before_action(only: [:destroy]) { process_permission has_delete_permission(:ou_attribute) }

  def index
  end
  def show
  end

  def new
    @ouPhone = OuPhone.new
    @ou = Ou.find(params[:ou_id])
    @ouPhone.ou = @ou
  end

  def edit
    @ouPhone = OuPhone.find(params[:id])
    @ou = Ou.find(params[:ou_id])
  end

  def update
    @ouPhone = OuPhone.find(params[:id]);
    @ou = Ou.find(params[:ou_id])
    respond_to do |f|
      if @ouPhone.update(ou_phone_new_params)
        f.html { redirect_to @ou}
        f.json { json_success }
      else
        f.html { render :edit, status: :unprocessable_entity }
        f.json { json_failure @ouPhone }
      end
    end
  end

  def create
    @ouPhone = OuPhone.new(ou_phone_new_params)
    @ou = Ou.find(params[:ou_id])
    @ouPhone.ou = @ou
    respond_to do |f|
    if @ouPhone.save
      f.html {
        flash[:success] = "Phone record created."
        redirect_to @ou }
      f.json { json_success }
    else
      f.html { render :new, status: :unprocessable_entity}
      f.json { json_failure @ouPhone }
    end
    end
  end

=begin
  def update
    @ouPhone = OuPhone.find(params[:id])
    @ou = Ou.find(params[:ou_id])
    if (@ouPhone.update ou_phone_params)
      redirect_to @ou
    else
      render 'edit'
    end
  end
=end

  def destroy
    @ou = Ou.find(params[:ou_id])
    @ouPhone = OuPhone.find(params[:id])
    @ouPhone.destroy
    respond_to do |f|
     f.html {redirect_to @ou}
     f.json { json_success }
    end
  end

  private
  def ou_phone_params
    params.require(:ou_phone).permit(:number ,:description)
  end

  def ou_phone_new_params
    params.require(:ou_phone).permit(:id, :ou_id, :number, :description)
  end

end
