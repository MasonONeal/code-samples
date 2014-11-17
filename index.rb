get '/' do
  erb :login_signup
end

get '/users/logout' do
  session[:user_id] = nil
  redirect '/'
end

post '/users/new' do
  @users = User.all
  @new_user = User.new(params)
  @new_user.password = params[:password]
  @new_user.save
  if @new_user.valid?
    User.login(params)
    session[:user_id] = @new_user.id
    redirect '/surveys'
  else
    @errors =  @new_user.errors.messages
    create_error_msgs(@errors)
    erb :login_signup
  end
end

post '/users' do
  user = User.login(params)
  if user
    session[:user_id] = user.id
    return ""
  else
    "Username and password not valid."
  end
end

get '/surveys' do
  user = current_user
  if logged_in?
    surveys = Survey.all
    @surveys = user.surveys
    erb :survey_all
  else
    redirect "/"
  end
end

get '/surveys/new' do
  if logged_in?
    erb :survey
  else
    redirect "/"
  end
end

get '/surveys/:id' do
  @current_survey = Survey.find(params[:id].to_i)
  @questions = @current_survey.questions
  erb :one_survey
end

post '/surveys/new' do
  current_survey = Survey.create(title: params[:title], user_id: session[:user_id])
  questions_hash = params[:questions][0]
  questions_hash.each do |key, question_array|
    current_question = Question.create(question_text: question_array.shift)
    current_survey.questions << current_question
    question_array.each do |choice|
      current_question.choices << Choice.create(choice_text: choice)
    end
  end
  redirect '/surveys'
end

get '/results' do
  @surveys = Survey.all
  erb :results
end

get '/results/:id' do
  @surveys = Survey.all
  erb :results
end
