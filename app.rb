require 'sinatra'
require 'erb'
# require "sinatra/cookies"

require "sqlite3"
require_relative "./my_user_model.rb"

db = SQLite3::Database.open "db.sql"

db.execute <<-SQL
    create table IF NOT EXISTS users (
    user_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    firstname str,
    lastname str,
    age int,
    password str,
    email str
  );
SQL

set :port, 8080
set :bind, '0.0.0.0'

user = User.new(db)

get '/' do
  'Hello! Go to /users'
end

# POST on /users. Receiving firstname, lastname, age, password and email. It will create a user and store in your database.
# $>curl -X POST -i http://web-XXXXXXXXX.docode.qwasar.io/users -d "firstname=value1" -d "lastname=value2" -d "age=value3" -d "password=value4" -d "email=value5"
# ...
# $>
post '/users' do
    firstname = params["firstname"]
    lastname = params["lastname"]
    age = params["age"]
    password = params["password"]
    email = params["email"]
    new_user = { 'firstname' => firstname, 'lastname' => lastname, 'age' => age, 'password' => password, 'email' => email }
    user.create(new_user)
    'CREATED'
end

# GET on /users. This action will return all users (without their passwords).
# curl localhost:5678/users
get '/users' do
    @all_users = user.all
    body = ""
    @all_users.each do |item|
        body += "user_id: #{item["user_id"]}, firstname: #{item["firstname"]}, lastname: #{item["lastname"]}, age: #{item["age"]}, email: #{item["email"]}, password: #{item["password"]}" + "\n"
    end
    body
    erb :index
end

# POST on /sign_in. 
# Receiving email and password. 
# It will add a session containing the user_id in order to be logged in
# curl -X POST -c cookies.txt localhost:5678/sign_in -d "email=lala@gmail.com" -d "password=12345"
enable :sessions

post '/sign_in' do
    email = params["email"]
    password = params["password"]
    user_id = user.find(email, password)
    if (user_id != nil)
        session["user_id"] = user.find(email, password)
        "user_id is #{session["user_id"]}"
    else
        "email or password is incorrect"
    end 
end

# PUT on /users. This action require a user to be logged in. 
# It will receive a new password and will update it. It returns the hash of the user.
put '/users' do
    password_value = params["password"]
    current_user_session_id = session["user_id"]
    if (current_user_session_id)
        user_hash = user.update(current_user_session_id, "password", password_value)
        "#{user_hash}"
    else
        "please sign in first"
    end
end

# DELETE on /sign_out. This action require a user to be logged in. It will sign_out the current user.
delete '/sign_out' do
    if (session["user_id"])
        session["user_id"] = nil
        "signed out successfully"
    else
        "you are not signed in"
    end
end

# DELETE on /users. This action require a user to be logged in. It will sign_out the current user and it will destroy the current user.
delete '/users' do
    if (session["user_id"])
        user.destroy(session["user_id"])
        session["user_id"] = nil
        "deleted successfully"
    else
        "you are not signed in"
    end
end