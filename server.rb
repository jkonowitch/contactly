require 'sinatra'
require_relative './db/connection'
require_relative './lib/category'
require_relative './lib/contact'
require_relative './lib/client'
require 'active_support'
require 'pry'

after do
  ActiveRecord::Base.connection.close
end

before '/*' do
  content_type :json
end

before '/api/*' do
  unless params["api_key"] && ( @client = Client.find_by({key: params["api_key"]}) )
    halt 400, 'Please provide an API key'
  end
end

post('/clients') do
  Client.create().to_json
end

get("/api/categories") do
  @client.categories.to_json
end

get("/api/categories/:id") do
  @client.categories.find(params[:id]).to_json(:include => :contacts)
end

post("/api/categories") do
  category = @client.categories.create(category_params(params))

  category.to_json
end

put("/api/categories/:id") do
  category = @client.categories.find_by(id: params[:id])
  category.update(category_params(params))

  category.to_json
end

delete("/api/categories/:id") do
  category = @client.categories.find(params[:id])
  category.destroy
  
  category.to_json
end

get("/api/contacts") do
  @client.contacts.to_json
end

get("/api/contacts/:id") do
  @client.contacts.find(params[:id]).to_json
end

post("/api/contacts") do
  contact = @client.contacts.create(contact_params(params))
  contact.to_json
end

put("/api/contacts/:id") do
  contact = @client.contacts.find(params[:id])
  contact.update(contact_params(params))

  contact.to_json
end

delete("/api/contacts/:id") do
  contact = @client.contacts.find(params[:id])
  contact.destroy

  contact.to_json
end

def category_params(params)
  params.slice(*Category.column_names)
end

def contact_params(params)
  params.slice(*Contact.column_names)
end
