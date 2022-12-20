require_relative '../../../handler/user_handler'

class ApplicationController < ActionController::Base

    skip_before_action :verify_authenticity_token

    before_action :validateUser

    #
    # Checks if user is logged in and the type of user.
    #
    def validateUser
        @isCustomer = false
        @isReceptionist = false
        @isHealthcareWorker = false

        jwt = session[:current_user_jwt]
        @user = UserHandler.getInstance.getUserWithJWT(jwt)
        if @user == nil
            flash[:notice] = "Error with user validation. Please log in again."
            redirect_to login_index_url
        else
            if @user.userType == UserType::Customer
                @isCustomer = true
            end
            if @user.userType == UserType::Receptionist
                @isReceptionist = true
            end
            if @user.userType == UserType::HealthcareWorker
                @isHealthcareWorker = true
            end
            gon.isCustomer = @isCustomer
            gon.isReceptionist = @isReceptionist
            gon.isHealthcareWorker = @isHealthcareWorker
            if @isReceptionist or @isHealthcareWorker
                gon.userTestingSiteId = @user.testingSiteId
            else
                gon.userTestingSiteId = nil
            end
        end
    end

end
