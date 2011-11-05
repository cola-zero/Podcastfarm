# -*- coding: utf-8 -*-
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

require 'spec_helper'

describe User do
  describe "attributes" do
    let(:attr) { { 
        :name     => 'こーら',
        :nickname => 'cola_zero'
      } }
    let(:user) { User.new(attr) }

    it 'should be valid' do
      user.should be_valid
    end

    context "name is empty" do
      it 'should not be valid' do
        attr.merge!(:name => "")
        user.should_not be_valid
      end
    end

    context "nickname is empty" do
      it 'should not be valid' do
        attr.merge!(:nickname => "")
        user.should_not be_valid
      end
    end
  end
end
