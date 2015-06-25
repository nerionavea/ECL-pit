require 'sinatra/base'

module Sinatra
	module Auth
		module Helpers
			def authorized?
				session[:started]
			end
			def protected!
				halt 401, haml(:login) unless authorized?
			end
			def login
				user = User.authenticate(params[:login])
				if user == false
					redirect to('/login')
				else
					session[:started] = true
					session[:email] = user.email
				end
			end
		end

		def self.registered(app)
			app.helpers Helpers

			app.enable :sessions

			app.get '/login' do
				haml :login, :layout => :layoutoutside
			end

			app.post '/login' do
				login
				redirect to ('/home')
			end
			app.get '/logout' do
				session.clear
				redirect to('/login')
			end
		end
	end
	register Auth
end