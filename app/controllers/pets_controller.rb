class PetsController < ApplicationController

  get '/pets' do
    @pets = Pet.all
    erb :'/pets/index'
  end

  get '/pets/new' do
    @owners = Owner.all
    erb :'/pets/new'
  end

  post '/pets' do
    @pet = Pet.new(:name => params[:pet_name])
    if !params[:owner_name].empty?
      @pet.owner = Owner.create(:name => params[:owner_name])
    elsif !params[:owner_id].empty?
      begin
        @pet.owner = Owner.find(params[:owner_id].to_i)
      rescue ActiveRecord::RecordNotFound => e
      end
    end
    @pet.save
    redirect to "pets/#{@pet.id}"
  end

  get '/pets/:id' do
    @pet = Pet.find(params[:id])
    erb :'/pets/show'
  end

  get '/pets/:id/edit' do
    begin
      @pet = Pet.find(params[:id].to_i)
      @owner = @pet.owner
      @owners = Owner.all
    rescue ActiveRecord::RecordNotFound => e
      "No such pet."
    else
      erb :'pets/edit'
    end
  end

  patch '/pets/:id' do
    begin
      @pet = Pet.find(params[:id].to_i)
    rescue ActiveRecord::RecordNotFound => e
      "No such pet."
    else
      @pet.name = params[:pet_name]
      if !params[:owner][:name].empty?
        @pet.owner = Owner.create(:name => params[:owner][:name])
      elsif !params[:owner_id].empty?
        begin
          @pet.owner = Owner.find(params[:owner_id].to_i)
        rescue ActiveRecord::RecordNotFound => e
          "No such owner"
        end
      end
      @pet.save
    end
  end
end
