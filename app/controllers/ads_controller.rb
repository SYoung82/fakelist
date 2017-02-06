

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
    #Verify user is logged in to create an ad
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
    #Verify that user owns ad in order to edit it.
    if @ad.user == current_user
      erb :'/ads/edit'
    else
      redirect to "/error"
    end
  end

  delete '/ads/:id/delete' do
    @ad = Ad.find_by_id(params[:id])
    #Check if user owns ad in order to delete it
    if @ad.user == current_user
      @ad.destroy
      redirect to '/ads'
    #Or if user is admin can also delete, redirects to different location though
    elsif current_user.is_admin
      @ad.destroy
      redirect to '/admins/manage_ads'
    else
      redirect to '/error'
    end
  end

  patch '/ads/:id' do
    #Get the add, Verify user owns the ad and that all fields were supplied, update all fields and save back to db
    @ad = Ad.find_by_id(params[:id])

    if current_user == @ad.user && !params[:title].empty? && !params[:content].empty? && !params[:section].empty?
      @ad.title = params[:title]
      @ad.content = params[:content]
      @ad.section_id = params[:section]
      @ad.save
      redirect to "/ads/#{@ad.id}"
    else
      redirect to "/ads/#{@ad.id}"
    end
  end

  post '/ads' do
    #Check if all fields are supplied and create add
    if params[:title] != "" && params[:content] != "" && params[:section]
      @ad = Ad.create(:title => params[:title], :content => params[:content], :section_id => params[:section])
      @user = current_user
      @user.ads << @ad
      redirect to "/ads/#{@ad.id}"
    else
      redirect to '/ads/new'
    end
  end

end
