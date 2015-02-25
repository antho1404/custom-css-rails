class CustomizationsController < ApplicationController

  before_action :find_model

  def index
    setting = @customization.settings.where(key: 'bg-color')
    setting.create value: 'red' unless setting.exists?
  end

  def update
    @customization.update_attributes permitted_params
    redirect_to root_path
  end

  private

  def find_model
    @customization = Customization.first || Customization.create
  end

  def permitted_params
    params.require(:customization).permit(settings_attributes: [:key, :value, :id])
  end
end
