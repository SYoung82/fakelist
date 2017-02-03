

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
    @user = current_user
    erb :'/ads/show'
  end

  get '/ads/:id/edit' do
    @ad = Ad.find_by_id(params[:id])
    if @ad.user_id == session[:id]
      erb :'/ads/edit'
    else
      redirect to "/ads"
    end
  end

  delete '/ads/:id/delete' do
    @ad = Ad.find_by_id(params[:id])
    @ad.destroy
    redirect to '/ads'
  end

  patch '/ads/:id' do
    @ad = Ad.find_by_id(params[:id])
    @ad.title = params[:title]
    @ad.content = params[:content]
    @ad.section_id = params[:section]
    @ad.save
    redirect to "/ads/#{@ad.id}"
  end

  post '/ads' do
    if params[:title] && params[:content] && params[:section_id]
      @ad = Ad.create(:title => params[:title], :content => params[:content], :section_id => params[:section])
      @user = current_user
      @user.ads << @ad
      redirect to "/ads/#{@ad.id}"
    else
      ###Error message undefined local variable or method 'flash'
      #flash[:error] = "Please fill in all fields!"
      redirect to '/ads/new'
    end
  end

end
