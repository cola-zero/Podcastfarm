# == Schema Information
#
# Table name: authorizations
#
#  id         :integer         not null, primary key
#  provider   :string(255)     not null
#  uid        :string(255)     not null
#  user_id    :integer         not null
#  created_at :datetime
#  updated_at :datetime
#

class Authorization < ActiveRecord::Base
  validates :provider, :presence => true
  validates :uid,      :presence => true
  validates :user_id,  :presence => true
end
