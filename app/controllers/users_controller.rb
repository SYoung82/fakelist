class UsersController < ApplicationController
  get '/signup' do
    if !logged_in?
      erb :'/users/signup'
    else
      redirect to '/ads'
    end
  end

  post '/signup' do
    #If any fields are left blank return to /signup
    if params[:username] == "" || params[:email] == "" || params[:password] ==""
      redirect to '/signup'
    #If user with provided username already exists return to /login
    elsif User.find_by(:username => params[:username]) != nil
      redirect to '/login'
    #Otherwise create new user, and log them in, defaulting to non admin
    else
      user = User.create(:username => params[:username], :email => params[:email], :password => params[:password], :is_admin => false)
      session[:id] = user.id
      redirect to '/ads'
    end
  end

  get '/login' do
    if logged_in?
      redirect to '/'
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(:username => params[:username])
    #binding.pry
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
    #Delete all of users ads, then delete user
    @user.ads.all.each do |ad|
      ad.destroy
    end
    @user.destroy
    redirect to '/admins/manage_users'
  end

  get '/users/:id/reset_password' do
    @user = User.find_by_id(params[:id])
    @user.password = "password"
    @user.save
    redirect to '/admins/manage_users'
  end
end
