# == Schema Information
#
# Table name: authorizations
#
#  id         :integer         not null, primary key
#  provider   :string(255)
#  uid        :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Authorization < ActiveRecord::Base

  attr_accessible :provider, :uid, :user, :user_id

  validates :provider, :presence => true
  validates :uid,      :presence => true
  validates :user_id,  :presence => true

  belongs_to :user, :dependent => :destroy

  def self.find_from_hash(auth)
    return false if auth == nil
    Authorization.find_by_provider_and_uid(auth['provider'], auth['uid'])
  end

  def self.create_from_hash(auth, user = :user_not_logged_in)
    user = User.create_from_hash(auth) if user == :user_not_logged_in || user == nil
    return false if user == false
    attr = { :provider => auth['provider'], :uid => auth['uid'], :user => user }
    auth = Authorization.create(attr)
    (auth.new_record?)? false : auth
  end
end
