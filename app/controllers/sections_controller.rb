class SectionsController < ApplicationController
  post '/sections' do
    @section = Section.find_by(:name => params[:section])
    erb :'/sections/index'
  end
end
