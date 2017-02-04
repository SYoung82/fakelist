class AdminsController < ApplicationController
  get '/admins' do
    #Check if current user has privileges to access admin page
    if current_user.is_admin
      erb :'/admins/index'
    else
      redirect to '/error'
    end
  end

  get '/admins/manage_sections' do
    if current_user.is_admin
      @sections = Section.all
      erb :'/admins/manage_sections'
    else
      redirect to '/error'
    end
  end

  get '/admins/manage_users' do
    if current_user.is_admin
      @users = User.all
      erb :'/admins/manage_users'
    else
      redirect to '/error'
    end
  end

  get '/admins/manage_ads' do
    if current_user.is_admin
      @ads = Ad.all
      erb :'/admins/manage_ads'
    else
      redirect to '/error'
    end
  end
end
