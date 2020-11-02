def get_user_hash(array)
    array.map do |fields|
        {'user_id' => fields[0], 'firstname' => fields[1], 'lastname' => fields[2], 'age' => fields[3], 'password' => fields[4], 'email' => fields[5]}
    end
end

class User
    def initialize(db)
        @db = db
    end
    def all()
        # It will retrieve all users and return a hash of users.
        users = @db.execute("select user_id, firstname, lastname, age, password, email from users")
        get_user_hash(users)
    end
    def create(hash)
        # It will create a user. User info will be: firstname, lastname, age, password and email
        # And it will return a unique ID (a positive integer)
        firstname = hash["firstname"]
        lastname = hash["lastname"]
        age = hash["age"]
        email = hash["email"]
        password = hash["password"]
        @db.execute("INSERT INTO users (firstname, lastname, age, password, email)
                     VALUES (?, ?, ?, ?, ?)", ["#{firstname}", "#{lastname}", age, "#{password}", "#{email}"])
        @db.execute("select last_insert_rowid()")
    end
    def destroy(user_id)
        #It will retrieve the associated user and destroy it from your database.
        @db.execute("DELETE FROM users WHERE user_id = #{user_id}")
    end
    def get(user_id)
        # It will retrieve the associated user and return all information contained in the database.
        @db.execute("SELECT * from users WHERE user_id = #{user_id}")
    end
    def update(user_id, attribute, value)
        #It will retrieve the associated user, update the attribute send as parameter with the value and return the user hash
        @db.execute("UPDATE users SET #{attribute} = '#{value}' WHERE user_id = #{user_id}")
        updated_user = @db.execute("SELECT user_id, firstname, lastname, age, password, email from users WHERE user_id = #{user_id}")
        get_user_hash(updated_user)
    end
    def find(user_value_email, user_value_password)
        user_id = @db.execute("SELECT user_id from users WHERE email = '#{user_value_email}' AND password = '#{user_value_password}'")
        if (!user_id.empty?)
            user_id[0][0]
        else
            nil
        end
    end
end