require 'spec_helper'

describe 'User' do
  before do
    @user = User.create(:username => "Scott Young", :email => "syoung@gmail.com", :password => "password")
    @ad1 = Ad.create(:title => "Scott's ad", :content => "For sale is one Sinatra Fakelist program")
    @ad2 = Ad.create(:title => "Scott's second ad", :content => "A bunch of other stuff for sale")
  end

  it 'creates an instance of class User' do
      expect(@user).to be_instance_of(User)
  end

  it 'creates a db entry for itself upon .create' do
    expect(User.find_by(:username => "Scott Young")).to eq(@user)
  end

  it 'can be assigned an ad' do
    @user.ads << @ad1
    expect(@user.ads.length).to eq(1)
    expect(@ad1.user).to eq(@user)
  end

  it 'can have multiple ads assigned to it' do
    @user.ads << @ad1
    @user.ads << @ad2
    expect(@user.ads.length).to eq(2)
    expect(@ad2.user).to eq(@user)
  end

  it 'has a secure password' do
    expect(@user.authenticate("notThePassword")).to eq(false)
    expect(@user.authenticate("password")).to eq(@user)
  end
end

describe 'Ad' do
  before do
    @user = User.create(:username => "Scott Young", :email => "syoung@gmail.com", :password => "password")
    @user2 = User.create(:username => "Layne Stackhouse", :email => "layne@gmail.com", :password => "password")
    @ad = Ad.create(:title => "Scott's ad", :content => "For sale is one Sinatra Fakelist program")
  end

  it 'creates an instance of class Ad' do
      expect(@ad).to be_instance_of(Ad)
  end

  it 'creates a db entry for itself upon .create' do
    expect(Ad.find_by(:title => "Scott's ad")).to eq(@ad)
  end

  it 'can be assigned to a user' do
    @ad.user = @user
    expect(User.find_by(:username => "Scott Young")).to eq(@ad.user)
  end

  it 'can be assigned to only one user' do
    @ad.user = @user2
    @ad.user = @user
    expect(@ad.user).to eq(@user)
    expect(@ad.user).not_to eq(@user2)
  end
end
