require 'rubygems'
require 'sinatra'
require 'mail'
require 'mustache'

configure do
  set :server, :puma
  set :root, File.dirname(__FILE__)

  Mail.defaults do
      delivery_method       :smtp,
      :address              => 'smtp.gmail.com',
      :port                 => 587,
      :authentication       => 'plain',
      :user_name            => 'katiecase28@gmail.com',
      :password             => 'G00d4me*',
      :domain               => 'gmail.com',
      :enable_starttls_auto => true
  end
end

get '/' do
  send_file File.expand_path('index.html', settings.public_folder)
end

post '/form_hook' do
  logger.info params
  send_email 'info@hshholdingsintl.com', "New Opportunity Signup", 'email_notification.html', params
  send_email params['Field3'], "Thank you for your interest", 'email_confirmation.html'
  redirect to('/hsh-thankyou.html')
end

def send_email(to, subject, filename, data={})
  root_folder = settings.root

  template = File.read File.join(root_folder, 'email', filename)
  rendered = Mustache.render template, data

  Mail.deliver do
    to           to
    from         'info@hshholdingsintl.com'
    subject      subject
    content_type 'text/html; charset=UTF-8'
    body         rendered
  end
end
