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

  get '/ads/new' do
    if logged_in?
      erb :'/ads/new'
    else
      redirect to '/login'
    end
  end

  get '/ads/:id' do
    @ad = Ad.find_by_id(params[:id])
    erb :'/ads/show'
  end

  get '/ads/:id/edit' do
    @ad = Ad.find_by_id(params[:id])
    if @ad.id = session[:id]
      erb :'/ads/edit'
    else
      redirect to "/ads"
    end
  end

  patch '/ads/:id' do
    @ad = Ad.find_by_id(params[:id])
    @ad.title = params[:title]
    @ad.content = params[:content]
    @ad.save
    redirect to "/ads/#{@ad.id}"
  end

  post '/ads' do
    @ad = Ad.create(:title => params[:title], :content => params[:content])
    @user = current_user
    @user.ads << @ad
    redirect to "/ads/#{@ad.id}"
  end
end
