class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
		set :session_secret, "super secret password_security"
  end

  get '/' do
    erb :index
  end
end
