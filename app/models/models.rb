class User
	include DataMapper::Resource
	property :id, Serial
	property :nick, String
	property :password, String
	property :active, Boolean, :default => true

	def self.authenticate(login)
    user = User.first(:nick => login[:nick])
    if user == nil
   		false
    else
    	user.password == login[:password] ? user : false
    end
    end
end

class Customer
	include DataMapper::Resource
	property :id, Serial
	property :first_name, String
	property :last_name, String
	property :cellphone, String
end

class Messages_config 
	include DataMapper::Resource
	property :id, Serial
	property :wdsl, String, :length => 100
	property :passport, String
	property :password, String
end

class Messages_record
	include DataMapper::Resource
	property :id, Serial
	property :date, Date
	property :text, String
	property :user, String
end


