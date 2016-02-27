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
    erb :index
end

post '/user/new' do
    @contribution = Contribution.create({
        mail: @user.mail,
        url: @content.url,
        name: @content.name,
        title: @content.title,
        body: @content.body,
        password: @user.password,
        password_confirmation: @user.password_confirmation
    })
    logger.info @contribution
    logger.info @contribution.errors
    
    # Contribution.create({
    #     url: params[:url],
    #     name: params[:name],
    #     title: params[:title],
    #     body: params[:body]
    # })

    redirect '/user/account/:id'
end

post '/user/delete/:id' do
    Contribution.find(params[:id]).destroy
    redirect '/user/account:id'
end

get '/user/edit/:id' do
    @content = Contribution.find(params[:id])
    erb :edit
end

post '/user/renew/:id' do
    @content = Contribution.find(params[:id])
    @content.update({
        name: params[:name],
        body: params[:body]
    })
    redirect '/'
end


get '/signin' do
    erb :sign_in
end



get '/signup' do
    @contents = Contribution.order('id desc').all
    erb :sign_up
end

post '/signup' do
    @user = Contribution.create(mail: params[:mail], password: params[:password],
    password_confirmation: params[:password_confirmation])
    
    if @user.persisted?
        session[:user] = @user.id
    end
    
    # @contents = Contribution.order('id desc').all
    # erb :account

    redirect '/user/account/:id'
end

post '/signin' do
    @user = Contribution.find_by(mail: params[:mail])
    if @user && @user.authenticate(params[:password])
        session[:user] = @user.id
    end
    redirect '/user/account'
    
end

get '/signout' do
    session[:user] = nil
    redirect '/'
end


before '/user/*' do
    @user_id = session[:user]
    redirect '/' if @user_id.nil?
    @user = Contribution.find(@user_id)
end

get '/user/account/:id' do
    @content = Contribution.order('id desc').all
    @contents = Contribution.order('id desc').all
    
    erb :account    
end

get '/user/upload' do
    erb :upload
end
