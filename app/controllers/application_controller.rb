class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
		set :session_secret, "super secret password_security"
  end

  get '/error' do
    erb :error
  end

  get '/' do
    @ads = Ad.all
    erb :index
  end

  helpers do
		def logged_in?
			!!current_user
		end

		def current_user
			@current_user ||= User.find(session[:id]) if session[:id]
		end
	end
end
