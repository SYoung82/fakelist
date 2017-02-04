class SectionsController < ApplicationController
  post '/sections' do
    @section = Section.find_by(:name => params[:section])
    erb :'/sections/index'
  end

  post '/sections/new' do
    if current_user.is_admin
      Section.create(:name => params[:name])
      redirect to '/admins/manage_sections'
    else
      redirect to '/error'
    end
  end
end
