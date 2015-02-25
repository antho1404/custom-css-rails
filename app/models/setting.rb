# == Schema Information
#
# Table name: settings
#
#  id               :integer          not null, primary key
#  key              :string           not null
#  value            :string           not null
#  customization_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Setting < ActiveRecord::Base
  belongs_to :customization

  validates :key, :value, :customization, presence: true
end
