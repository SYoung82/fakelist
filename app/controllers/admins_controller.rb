class AdminsController < ApplicationController
  get '/admins' do
    if current_user.is_admin
      erb :'/admins/index'
    else
      redirect to '/'
    end
  end

  get '/admins/manage_sections' do
    @sections = Section.all
    erb :'/admins/manage_sections'
  end

  get '/admins/manage_users' do
    @users = User.all
    erb :'/admins/manage_users'
  end

  get '/admins/manage_ads' do
    @ads = Ad.all
    erb :'/admins/manage_ads'
  end
end
