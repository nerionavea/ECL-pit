DataMapper::Property::String.length(1000)
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

class Billing
	include DataMapper::Resource
	property :id, Serial
	property :year, Integer
	property :month, Integer
	has n, :messages

	def self.get_actual_bill
		if self.actual_bill_exist?
			self.first(self.get_month_year)
		else
			self.create(self.get_month_year)
		end
	end

	def self.actual_bill_exist?
		if self.first(self.get_month_year) != nil
			true
		else
			false
		end
	end

	def self.get_month_year
		{:month => Time.now.strftime("%-m"), :year => Time.now.strftime("%Y")}
	end

	def self.get_messages_bill
		get_actual_bill.messages.count
	end
end

class Message
	include DataMapper::Resource
	property :id, Serial
	property :to, String
	property :text, String
	property :date, Date
	belongs_to :billing

	def self.collect(to,text)
		Billing.get_actual_bill.messages.create(:to => to, :text => text, :date => Time.now)
	end
end


