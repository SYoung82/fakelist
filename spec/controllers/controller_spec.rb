require 'spec_helper'

describe ApplicationController do

  describe "Homepage" do

    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome to Fakelist")
    end

    it 'has login link' do
      get '/'
      click_link('login')
      expect(page.current_path).to eq('/login')
    end

    it 'has signup link' do
      get '/'
      click_link 'signup'
      expect(page.current_path).to eq('/signup')
    end
  end

  describe "Signup" do

    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'directs user to index of users ads' do
      params = {
        :username => "Heidi",
        :email => "heidi@mail.com",
        :password => "password"
      }
      post '/signup', params
      expect(last_response.location).to include('/ads')
    end

    it 'does not allow for a missing username' do
      params = {
        :username => "",
        :email => "heidi@mail.com",
        :password => "password"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not allow for a missing email' do
      params = {
        :username => "Heidi",
        :email => "",
        :password => "password"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not allow for a missing password' do
      params = {
        :username => "Heidi",
        :email => "heidi@mail.com",
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'redirects a logged in user to his/her ads page' do
      user = User.create(:username => "Scott", :email => "scott@mail.com", :password => "password")
      params = {
        :username => "Scott",
        :password => "password"
      }

      post '/signup', params
      session = {}
      session[:id] = user.id
      get '/signup'
      expect(last_response.location).to include('/ads')
    end
  end

  describe "Login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'redirects to the users ads page after login' do
      user = User.create(:username => "Kristen", :email => "kristen@mail.com", :password => "password")
      params = {
        :username => "Kristen",
        :password => "password"
      }

      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome #{user.username}")
    end

    it 'does not display log in page if user already logged in' do
      user = User.create(:username => "Scott", :email => "scott@mail.com", :password => "password")
      params = {
        :username => "Scott",
        :password => "password"
      }

      post '/login', params
      session ={}
      session[:id] = user.id
      get '/login'
      expect(last_response.location).to include("/ads")
    end
  end

  describe "Logout" do
    it 'logs out a logged in user and returns to login page' do
      user = User.create(:username => "Kristen", :email => "kristen@mail.com", :password => "password")
      params = {
        :username => "Kristen",
        :password => "password"
      }
      post '/login', params
      post '/logout'
      expect(last_response.location).to include('/login')
    end

    it 'displays homepage if no user is logged in to log out' do
      get '/logout'
      expect(last_response.location).to include('/')
    end
  end

  describe "User Ads (/ads/index.erb via /ads)" do
    it 'does not load if no user logged in' do
      get '/ads'
      expect(last_response.location).to include("/login")
    end

    it 'does load /ads if user is logged in' do
      user = User.create(:username => "Scott", :email => "scott@mail.com", :password => "password")
      visit '/login'
      fill_in(:username, :with => "Scott")
      fill_in(:password, :with => "password")
      click_button 'submit'
      expect(page.current_path).to eq('/ads')
    end
  end

  describe "Individual ads page (/ads/:id)" do
    it 'displays the ad page' do
      user = User.create(:username => "Kristen", :email => "kristen@mail.com", :password => "password")
      ad = Ad.create(:title => "Kristen's Ad", :content => "Sweet ad bro.", :user_id => user.id)
      get "/ads/#{ad.id}"
      expect(last_response.body).to include("Kristen's Ad")
    end

    it 'has an edit button that takes user to edit ad page' do
      user = User.create(:username => "Kristen", :email => "kristen@mail.com", :password => "password")
      ad = Ad.create(:title => "Kristen's Ad", :content => "Sweet ad bro.", :user_id => user.id)
      get "/ads/#{ad.id}"
      click_button("Edit")
      expect(last_response.location).to include('/edit')
    end

    it 'has a delete button that deletes ad and returns to users ad page' do
      user = User.create(:username => "Kristen", :email => "kristen@mail.com", :password => "password")
      ad = Ad.create(:title => "Kristen's Ad", :content => "Sweet ad bro.", :user_id => user.id)
      get "/ads/#{ad.id}"
      click_button("Delete")
      expect(User.find_by(:username => "Kristen")).to eq(nil)
      expect(last_response.location).to include('/ads')
    end
  end

  describe "Edit ad page" do
    it 'has title and content edit boxes' do
      user = User.create(:username => "Kristen", :email => "kristen@mail.com", :password => "password")
      ad = Ad.create(:title => "Kristen's Ad", :content => "Sweet ad bro.", :user_id => user.id)
      get "ads/#{ad.id}/edit"
      fill_in(:title, :with => "Kristen's Edited Ad")
      fill_in(:content, :with => "Even sweeter ad, bro.")
      click_button 'submit'
      expect(last_response.location).to include("/ads/#{ad.id}")
    end

    it 'saves and shows the edited ad after submittion' do
      user = User.create(:username => "Kristen", :email => "kristen@mail.com", :password => "password")
      ad = Ad.create(:title => "Kristen's Ad", :content => "Sweet ad bro.", :user_id => user.id)
      get "ads/#{ad.id}/edit"
      fill_in(:title, :with => "Kristen's Edited Ad")
      fill_in(:content, :with => "Even sweeter ad, bro.")
      click_button 'submit'
      expect(last_response.body).to include("Kristen's Edited Ad")
      expect(last_response.body).to include("Even sweeter ad, bro.")
    end

    it 'overwrites the old ad' do
      user = User.create(:username => "Kristen", :email => "kristen@mail.com", :password => "password")
      ad = Ad.create(:title => "Kristen's Ad", :content => "Sweet ad bro.", :user_id => user.id)
      get "ads/#{ad.id}/edit"
      fill_in(:title, :with => "Kristen's Edited Ad")
      fill_in(:content, :with => "Even sweeter ad, bro.")
      click_button 'submit'
      expect(User.find_by(:title => "Kristen's Ad")).to eq(nil)
    end

    it 'does not display the ad for editing if it doesnt belong to logged in user' do
      user = User.create(:username => "Kristen", :email => "kristen@mail.com", :password => "password")
      user2 = User.create(:username => "Scott", :email => "scott@mail.com", :password => "password")
      ad = Ad.create(:title => "Scott's Ad", :content => "Sweet ad bro.", :user_id => user2.id)
      get '/login'
      fill_in(:username, :with => "Kristen")
      fill_in(:password, :with => "password")
      click_button 'submit'
      get "/ads/#{ad.id}/edit"
      expect(last_response.location).to include("/ads")
    end
  end

  describe "New ad page" do
    it 'has edit boxes for title, and content' do
      get '/ads/new'
      fill_in(:title, :with => "New ad")
      fill_in(:content, :with => "Hot fresh ad for posting.")
      click_button 'submit'
    end

    it 'stores a new ad in db and associates it with logged in user' do
      user = User.create(:username => "Kristen", :email => "kristen@mail.com", :password => "password")
      params = {
        :username => "Kristen",
        :password => "password"
      }

      post '/login', params
      get '/ads/new'
      fill_in(:title, :with => "New ad")
      fill_in(:content, :with => "Hot fresh ad for posting.")
      click_button 'submit'
      expect(user.ads.last.title).to eq("New ad")
    end

    it 'displays the new ad' do
      user = User.create(:username => "Kristen", :email => "kristen@mail.com", :password => "password")
      params = {
        :username => "Kristen",
        :password => "password"
      }

      post '/login', params
      get '/ads/new'
      fill_in(:title, :with => "New ad")
      fill_in(:content, :with => "Hot fresh ad for posting.")
      click_button 'submit'
      expect(last_response.body).to include("Hot fresh ad for posting.")
    end

    it 'does not display if user not logged in' do
      get '/ads/new'
      expect(last_response.location).to include('/login')
    end
  end
end
