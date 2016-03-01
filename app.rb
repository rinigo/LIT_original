require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'sinatra/json'
require './image_uploader.rb'
require './models/bbs.rb'

enable :sessions

get '/' do
    @contents = Contribution.order('id desc').all
    @categories = Contribution.categories
    
    erb :index
end

get '/category/:id' do
    @contents = Contribution.where(category:'id')
    erb :category
end

get '/signin' do
    erb :sign_in
    
end


post '/signin' do
    @user = User.find_by(mail: params[:mail])
    if @user && @user.authenticate(params[:password])
        session[:user] = @user.id
    end
    redirect '/user/account/:id'
    
end

get '/signup' do
    erb :sign_up
end

post '/signup' do
    @user = User.create(mail: params[:mail], password: params[:password],
    password_confirmation: params[:password_confirmation])
    
    if @user.persisted?
        session[:user] = @user.id
    end
    
    redirect '/user/account/:id'
end


get '/signout' do
    session[:user] = nil
    redirect '/'
end


before '/user/*' do
    @user_id = session[:user]
    redirect '/' if @user_id.nil?
    @user = User.find(@user_id)
end

get '/user/account' do
    @contents = @user.contributions.order('id desc').all
    @categories = Contribution.categories
    erb :account    
end

get '/user/category/:id' do
    @contents = Contribution.where(category:'id')
    erb :user_category
  
end

get '/user/upload' do
    erb :upload
end

post '/user/upload' do
     @contribution = @user.contributions.create({
         url: params[:url],
         title: params[:title],
         body: params[:body],
         category: params[:category]
     })

    logger.info @contribution
    logger.info @contribution.errors
    redirect '/user/account'
end

post '/user/delete/:id' do
    @user.contributions.find(params[:id]).destroy
    redirect '/user/account/#{@user}'
end

get '/user/edit/:id' do
    @content = @user.contributions.find(params[:id])
    erb :edit
end

post '/user/renew/:id' do
    @content = @user.contributions.find(params[:id])
    @content.update({
        url: params[:url],
        title: params[:title],
        body: params[:body],
        category: params[:category]
    })
    redirect '/user/account'
end

