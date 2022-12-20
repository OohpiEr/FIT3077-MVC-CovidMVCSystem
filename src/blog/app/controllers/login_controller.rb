class LoginController < ApplicationController

  skip_before_action :validateUser

  def index
  end

end
