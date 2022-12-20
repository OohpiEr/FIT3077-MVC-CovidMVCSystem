require_relative '../../../handler/package'
require_relative '../../../user/user_type'
require_relative 'booking_updater'

class CreateBookingController < ApplicationController

  include BookingUpdater

  def index
  end

  def create

    userHandler = UserHandler.getInstance
    testingSiteHandler = TestingSiteHandler.getInstance


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

    if params[:testingSiteId] == ""
      valid = false
      flash[:notice] << "Testing Site ID is required!"
    else
      testingSiteHandler = TestingSiteHandler.getInstance
      if testingSiteHandler.getTestingSite(params[:testingSiteId]) == nil
        valid = false
        flash[:notice] << "Invalid Testing Site ID!"
      end
    end

    if params[:startTime] == ""
      valid = false
      flash[:notice] << "Start Time is required!"
    end

    if params[:notes] == ""
      valid = false
      flash[:notice] << "Notes should not be empty!"
    end

    if !valid
      redirect_to action: 'index'
    else
      bookingHandler = BookingHandler.getInstance
      booking = bookingHandler.addBooking(customer.id, params[:testingSiteId], params[:startTime], params[:notes])
      if booking != nil
        flash[:notice] << "Booking created with ID: #{booking.id}"
        flash[:notice] << "Booking PIN: #{booking.smsPin}"
        bookingUpdated(booking.id, "New Booking Created", booking.getTestingSiteId)
      else
        flash[:notice] << "Booking could not be created"
      end
      redirect_to action: 'index'
    end
  end
end
