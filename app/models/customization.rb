# == Schema Information
#
# Table name: customizations
#
#  id         :integer          not null, primary key
#  stylesheet :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Customization < ActiveRecord::Base
  include Customizable

  has_many :settings, dependent: :destroy

  accepts_nested_attributes_for :settings, reject_if: :all_blank

  mount_uploader :stylesheet, StylesheetUploader

  before_save :compile_css
end
