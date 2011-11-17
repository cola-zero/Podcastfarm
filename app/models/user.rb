# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)     not null
#  nickname   :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  validates :name, :presence => true
  validates :nickname, :presence => true

  has_many :authorization

  def self.find_or_create_from_hash(auth_hash, user = :user_not_presented)
    return false if auth_hash == nil
    auth = Authorization.find_from_hash(auth_hash)
    return auth.user if auth != nil
    user = User.create_from_hash(auth_hash) if user == :user_not_presented || user == nil
    auth = Authorization.create_from_hash(auth_hash, user)
    (auth != false)? auth.user : false
  end

  def self.create_from_hash(auth_hash)
    return false if auth_hash['info'] == nil
    user = User.create({ :name => auth_hash['info']['name'],
                         :nickname => auth_hash['info']['nickname'] })
    (user.new_record?)? false : user
  end
end
