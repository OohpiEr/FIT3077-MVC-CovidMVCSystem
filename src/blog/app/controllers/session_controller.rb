require_relative '../../../handler/package'
require_relative '../../../user/package'

class SessionController < ApplicationController

  skip_before_action :validateUser

  def index
  end

  def create
    userHandler = UserHandler.getInstance
    details = params[:login]
    response = userHandler.login(details[:username], details[:password], true)
    if response[:success]
      session[:current_user_jwt] = response[:data][:jwt]
      user = userHandler.getUserWithJWT(response[:data][:jwt])
      redirect_to :home_index
    else
      redirect_to :login_index , notice: "Invalid Credentials!"
    end

  end

end