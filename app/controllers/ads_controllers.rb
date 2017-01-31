class AdsController < ApplicationController
  get '/ads' do
    #If user logged in, find them by id and display ad page
    if logged_in?
      @user = User.find_by_id(session[:id])
      erb :'/ads/index'
    #Otherwise redirect to login page
    else
      redirect to '/login'
    end
  end
end
