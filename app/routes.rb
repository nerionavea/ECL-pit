get '/' do
	protected!
	redirect to ('/home')
end

get '/home' do 
	protected!
	haml :home
end

get '/customers' do
	protected!
	@title = "Clientes"
	@Customers = Customer.all()
	haml :customers
end

get '/customers/new' do
	protected!
	@title = "Nuevo Cliente"
	@Customer = Customer.new()
	haml :customer_new
end

get '/customer/edit/:id' do
	@title = "Editar cliente"
	haml :customer_edit
end

put '/customer/edit/:id' do
	Customer.get(params[:id]).update(params[:customer])
end


get '/message' do
	protected!
	@title = "Envíar Mensaje"
	haml :message_form
end

post '/message' do
	protected!
	messenger = SMS.new
	messenger.send_masive_sms(params[:smstext])
	Messages_record.create(:date => Time.now, :text => params[:smstext], :user => session[:user])
	redirect to ('/home')
end

post '/customers/new' do 
	protected!
	Customer.create(params[:customer])
	redirect to ('/customers')
end

get '/records' do
	protected!
	@Records = Messages_record.all.reverse
	haml :records
end

get '/admin_config' do
	protected!
	if Messages_config.first() == nil
		haml :config_new
	else
		haml :config_edit
	end
end

post '/admin_config' do
	protected!
	Messages_config.create(params[:sms])
end

put '/admin_config' do
	protected!
	Messages_config.first().update(params[:sms])
	redirect to ('/admin_config')
end

get '/admin/users' do
	protected!
	@users = User.all
	haml :users
end

get '/admin/users/new' do
	protected!
	@user = User.new
	haml :user_new 
end

post '/admin/users/new' do
	protected!
	if params[:user][:password] == params[:user][:password2] 
		user_data= { :nick => params[:user][:nick], :password => params[:user][:password] }
		user = User.create(user_data)
		redirect to ('/admin/users')
	else
		redirect to ('/admin/users/new')
	end

end
get '/admin/users/edit/:id' do
	protected!
	@user = User.get(params[:id])
	haml :user_edit
end

put '/admin/users/edit/:id' do
	protected!
	if params[:user][:password] == params[:user][:password2] 
		user_data= { :nick => params[:user][:nick], :password => params[:user][:password] }
		@User = User.get(params[:id]).update(user_data)
		redirect to ('/admin/users')
	else
		redirect to ("/admin/users/edit/#{user.id}")
	end

end
