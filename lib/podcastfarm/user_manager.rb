module Podcastfarm
  class UserManager
    def self.find_from_hash(auth_hash)
      auth = Authorization.find_from_hash(auth_hash)
      return false if auth == false || auth == nil
      return auth.user
    end

    ## TODO: hanle multiple provider.

    def self.create_from_hash(auth_hash)
      user = User.create_from_hash(auth_hash)
      auth = Authorization.create_from_hash(auth_hash, user)
      (auth == false ) ? false : user
    end

    def self.find_or_create_from_hash(auth_hash)
      return false if auth_hash == nil
      user = find_from_hash(auth_hash)
      return user unless user == false
      return create_from_hash(auth_hash)
    end
  end
end
