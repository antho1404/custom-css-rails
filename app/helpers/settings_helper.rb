module SettingsHelper
  def setting_field form, key
    setting_value form, key
  end

  def render_settings form
    form.fields_for :settings do |ff|
      content_tag :div do
        label = ff.label ff.object.key
        key   = ff.hidden_field :key
        value = ff.text_field :value
        label + key + value
      end
    end
  end

  private

  def setting_value form, key
    setting = form.object.settings.where(key: key).first
    setting = form.object.settings.build key: key, value: Customizable.default_setting[key] unless setting
    setting
  end
end
