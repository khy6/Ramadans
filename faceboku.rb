require 'sinatra'
require 'omniauth/oauth'

enable :sessions

#Here you have to put your own Application ID and Secret
APP_ID = "117650764995333"
APP_SECRET = "a9ee5ff55625f387c3256711f5549fd2"

use OmniAuth::Builder do
  provider :facebook, APP_ID, APP_SECRET, { :scope => 'email, status_update, publish_stream' }
end

get '/' do
    @articles = []
    @articles << {:title => 'What is Ramadan? An Explanation by Yusuf Islam', :url => 'http://www.youtube.com/watch?v=Ta8j1z5LkJo'}
    @articles << {:title => 'My first Ramadan', :url => 'http://www.youtube.com/watch?v=DOaET--aai8&feature=related'}
    @articles << {:title => 'Ramadan Explained by the BBC', :url => 'http://www.bbc.co.uk/religion/religions/islam/practices/ramadan_1.shtml'}
    @articles << {:title => 'Birmingham Ramadan Timetable', :url => 'http://www.ramadantimetable.co.uk/ramadantimetable-uk/birmingham'}



    erb :index
end

get '/auth/facebook/callback' do
  session['fb_auth'] = request.env['omniauth.auth']
  session['fb_token'] = session['fb_auth']['credentials']['token']
  session['fb_error'] = nil
  redirect '/'
end

get '/auth/failure' do
  clear_session
  session['fb_error'] = 'In order to use this site you must allow us access to your Facebook data<br />'
  redirect '/'
end

get '/logout' do
  clear_session
  redirect '/'
end

def clear_session
  session['fb_auth'] = nil
  session['fb_token'] = nil
  session['fb_error'] = nil
end
