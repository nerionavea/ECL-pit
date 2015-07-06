require 'sinatra/base'

module Sinatra
	module Auth
		module Helpers
			def calculate_total
				messagesconsumed = Billing.get_messages_bill
				if messagesconsumed > 3000
					((messagesconsumed - 3000) * 0.70) + 2500
				else
					2500
				end
			end

		end

		def self.registered(app)
			app.helpers Helpers

			app.get '/admin/sms' do
				protected!
				@title = "Saldo"
				@bill = Billing.get_actual_bill
				@smscount = Billing.get_messages_bill
				@total = calculate_total
				haml :billing
			end
		end
	end
	register Auth
end