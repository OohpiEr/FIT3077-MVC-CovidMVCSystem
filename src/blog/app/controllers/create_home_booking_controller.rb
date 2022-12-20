require_relative '../../../handler/user_handler'
require_relative '../../../handler/booking_handler'
require_relative '../../../user/user_type'

#
# Controller for create_home_booking
#
class CreateHomeBookingController < ApplicationController
  
    def index; end

    #
    # Controller for create_home_booking/create
    #
    def create
        userHandler = UserHandler.getInstance

        valid = true
        flash[:notice] = []
        
        if params[:username] == ""
            valid = false
            flash[:notice] << "Customer Username is required!"
        else
            userHandler = UserHandler.getInstance
            customer = userHandler.getUserWithUsername(params[:username])
            if customer == nil
                valid = false
                flash[:notice] << "Invalid Customer Username!"
            elsif customer.userType != UserType::Customer
                valid = false
                flash[:notice] << "User is not a customer!"
            end
        end

        if params[:startTime] == ""
            valid = false
            flash[:notice] << "Start Time is required!"
        end

        if params["has_testkit"] == "1"
            has_testkit = "has testkit"
        else
            has_testkit = "no testkit"
        end

        if !valid
            redirect_to action: 'index'
        else
            bookingHandler = BookingHandler.getInstance
            booking = bookingHandler.addBooking(customer.getId, "", params[:startTime], params[:notes], has_testkit)
            if booking != nil
                flash[:notice] << "Booking created with ID: #{booking.id}"
                flash[:notice] << "Booking PIN: #{booking.smsPin}"
                flash[:notice] << "QR code: #{booking.getQrCode}"
            else
                flash[:notice] << "Booking could not be created"
            end
            redirect_to action: 'index'
        end
    end
end
