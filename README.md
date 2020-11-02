# my_users_app

- User class stored in <u>my_user_model.rb</u> file <br>
- To run the server and create data base use <u>app.rb</u>
- In the project I used Sinatra

## Curl requests.

### POST
curl -X POST -i https://web-XXXXXXXXX-XXXX.docode.qwasar.io/users -d "firstname=Emma" -d "lastname=Joe" -d "age=40" -d "password=123456ue4" -d "email=joe@gmail.com"

### GET
curl https://web-XXXXXXXXX-XXXX.docode.qwasar.io/users

### POST on /sign_in
curl -X POST -i -c cookies.txt https://web-XXXXXXXXX-XXXX.docode.qwasar.io/sign_in -d "email=joe@gmail.com" -d "password=123456ue4"
curl -X POST -i -c cookies.txt https://web-XXXXXXXXX-XXXX.docode.qwasar.io/sign_in -d "email=hello@gmail.com" -d "password=12345"

### PUT on /users for changing password
 - works if user was signed in (POST on /sign_in)
 - copy cookies from previous POST requests (for signing in)
 - curl -X PUT -H 'Cookie: rack.session=XXX...' https://web-XXXXXXXXX-XXXX.docode.qwasar.io/users -d "password=secured3"

 ### DELETE on /sign_out
 - works if user was signed in (POST on /sign_in)
 - copy cookies from previous POST requests (for signing in)
 - curl -X DELETE -H 'Cookie: rack.session=XXX...' https://web-XXXXXXXXX-XXXX.docode.qwasar.io/sign_out

 ### DELETE on /users

 - curl -X DELETE -H 'Cookie: rack.session=XXX...' https://web-XXXXXXXXX-XXXX.docode.qwasar.io/users

