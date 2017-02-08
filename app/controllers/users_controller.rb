class UsersController < ApplicationController
  get '/signup' do
    #If a user is not already logged in render signup page otherwise show home
    if !logged_in?
      erb :'/users/signup'
    else
      redirect to '/ads'
    end
  end

  post '/signup' do
    redirect to '/' if logged_in?
    @user = User.new(params)
    if @user.save
      redirect to '/'
    else
      flash[:erro]r = @user.errors.full_messages
      redirect to '/signup'
    end
  end

  get '/login' do
    #If already logged in redirect to home otherwise render login page
    if logged_in?
      redirect to '/'
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(:username => params[:username])
    #Authenticate user or redirect to login again
    if @user && @user.authenticate(params[:password])
      session[:id] = @user.id
      redirect to '/'
    else
      redirect to '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect to '/login'
  end

  delete '/users/:id/delete' do
    @user = User.find_by_id(params[:id])
    if current_user.is_admin || current_user == @user
      #Delete all of users ads, then delete user
      @user.ads.all.each do |ad|
        ad.destroy
      end
      @user.destroy
      redirect to '/admins/manage_users'
    else
      redirect to '/error'
    end
  end

  patch '/users/:id/reset_password' do
    #Verify current user has admin privileges to reset password
    if current_user.is_admin
      @user = User.find_by_id(params[:id])
      @user.password = "password"
      @user.save
      redirect to '/admins/manage_users'
    else
      redirect to '/error'
    end
  end

  get '/users/change_password' do
    #Check if user logged in and display change password form, otherwise redirect to permission error
    if logged_in?
      erb :'/users/change_password'
    else
      redirect to '/error'
    end
  end

  patch '/users/change_password' do
    #if the current user's password was input correctly and the new password fields match
    #update current_user's password
    if current_user.authenticate(params[:current]) && params[:new] == params[:verify]
      current_user.password = params[:new]
      current_user.save
      redirect to '/'
    else
      redirect to 'users/change_password'
    end
  end

  patch '/users/:id/make_admin' do
    #if current user is admin find user by :id and set is_admin flag to true
    if current_user.is_admin
      user = User.find_by_id(params[:id])
      user.is_admin = true
      user.save
      redirect to '/admins/manage_users'
    else
      redirect to '/error'
    end
  end

  patch '/users/:id/revoke_admin' do
    #if current user is admin find user by :id and set is_admin flag to false
    if current_user.is_admin
      user = User.find_by_id(params[:id])
      user.is_admin = false
      user.save
      redirect to '/admins/manage_users'
    else
      redirect to '/error'
    end
  end
end
