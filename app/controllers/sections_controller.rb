class SectionsController < ApplicationController
  post '/sections' do
    @section = Section.find_by(:name => params[:section])
    erb :'/sections/index'
  end

  post '/sections/new' do
    Section.create(:name => params[:name])
    redirect to '/admins/manage_sections'
  end
end
