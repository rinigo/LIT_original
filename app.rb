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
    @categories = Category.all
    
    erb :index
end

get '/category/:id' do
    @categories = Category.all
    @category = Category.find(params[:id])
    @category_name = @category.name
    @contents = @category.contributions
    
    redirect '/'
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
    # @contents = Contribution.order('id desc').all
    erb :sign_up
end

post '/signup' do
    @user = User.create(mail: params[:mail], password: params[:password],
    password_confirmation: params[:password_confirmation])
    
    if @user.persisted?
        session[:user] = @user.id
    end
    
    # @contents = Contribution.order('id desc').all
    # erb :account

    redirect "/user/account/#{@user.id}"
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

get '/user/account/:id' do
    #@contents = Contribution.order('id desc').all
    #@contents = User.all
    #@content = User.find(params[:id]
    @categories = Category.all
    @contents = User.all
    
    
    erb :account    
end

get '/user/account/:uid/category/:cid' do
    @category = Category.find(params[:id])
    @contents = @category.contributions
    #@contents = Contribution.order('id desc').all
    #@categories = Category.all
    #@category = Category.find_by(id: params[:cid])

    erb :account    
end

get '/user/upload' do
    @categories = Category.all
    erb :upload
end

post '/user/upload/:id' do
     @contribution = Contribution.create({
         url: params[:url],
       title: params[:title],
         body: params[:body],
         category_id: params[:category]
     })

   # @contribution = Contribution.create({
        # url: @content.url,
        #title: @content.title,
        #body: @content.body,
        #password: @user.password,
        #password_confirmation: @user.password_confirmation
    #})
    logger.info @contribution
    logger.info @contribution.errors
    


    redirect "/user/account/#{@user.id}"
end

post '/user/delete/:id' do
    Contribution.find(params[:id]).destroy
    redirect '/user/account/#{@user.id}'
end

get '/user/edit/:id' do
    @content = Contribution.find(params[:id])
    erb :edit
end

post '/user/renew/:id' do
    @content = Contribution.find(params[:id])
    @content.update({
        url: params[url],
        title: params[:title],
        body: params[:body]
    })
    redirect '/user/account/#{@user.id}'
end

get '/user/category/:id' do
    @category = Category.find(params[:id])
    @contents = @category.contributions
    #@categories = Category.all
    #@category = Category.find(params[:id])
    #@category_name = @category.name
    #@contents = @category.contributions
    
    redirect "/user/account/#{session[:user]}/category/#{params[:id]}"
end