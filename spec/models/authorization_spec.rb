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

require 'spec_helper'

describe Authorization do
  describe "attributes" do
    let(:attr) { { 
        :provider => 'twitter',
        :uid => 'asdfg',
        :user_id => 42
      }}
    let(:authorization) { Authorization.new(attr) }

    it "should be valid" do
      authorization.should be_valid
    end

    context "provider is empty" do
      it "should not be valid" do
        attr.merge!(:provider => "")
        authorization.should_not be_valid
      end
    end

    context "uid is empty" do
      it "should not be valid" do
        attr.merge!(:uid => "")
        authorization.should_not be_valid
      end
    end

    context "user_id is empty" do
      it "should not be valid" do
        attr.merge!(:user_id => nil)
        authorization.should_not be_valid
      end
    end
  end
end
