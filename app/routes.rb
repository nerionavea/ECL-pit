get '/' do 
	redirect to ('/home')
end

get '/home' do 
	haml :home
end

get '/customers' do
	@title = "Clientes"
	@Customers = Customer.all()
	haml :customers
end

get '/customers/new' do
	@title = "Nuevo Cliente"
	@Customer = Customer.new()
	haml :customer_new
end

get '/message' do
	@title = "Envíar Mensaje"
	haml :message_form
end

post '/message' do
	messenger = SMS.new
	messenger.send_masive_sms(params[:smstext])
	Messages_record.create(:date => Time.now, :text => params[:smstext])
	redirect to ('/home')
end

post '/customers/new' do 
	Customer.create(params[:customer])
	redirect to ('/customers/')
end

get '/records' do
	@Records = Messages_record.all
	haml :records
end

get '/admin_config' do
	if Messages_config.first() == nil
		haml :config_new
	else
		haml :config_edit
	end
end

post '/admin_config' do
	Messages_config.create(params[:sms])
end

put '/admin_config' do
	Messages_config.first().update(params[:sms])
	redirect to ('/admin_config')
end

