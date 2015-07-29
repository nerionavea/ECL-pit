class SMS
	def initialize()
		@config = Messages_config.first()
		@client = Savon.client(wsdl: 'http://200.41.57.109:8086/m4.in.wsint/services/M4WSIntSR?wsdl')
	end

	def send_masive_sms(text)
		@customers = Customer.all
		@customers.each do |customer|
			transformed_text = text.gsub('(Nombre)', customer.first_name).gsub('(Apellido)', customer.last_name)
			if customer.cellphone != nil
				divide_and_send_message(customer.cellphone, transformed_text)
				sleep 3
			end
		end
	end
	def divide_and_send_message(to,text)
		sended_point = 0
		while text.length > sended_point
			send_sms(to, text[sended_point, 160])
			sended_point += 160
		end
	end
	def send_sms(to,text)
		@client.call(:send_sms, message: {
		'passport' => @config.passport, 
		'password' => @config.password, 
		'number' => convert_number_to_international(to), 
		'text' => text})
		Message.collect(to,text)
	end
	def convert_number_to_international(number)
		#Verify if 'number' its not a real number
		if number.length >= 10 
			'58' + number[-10..10]
		end
	end
end