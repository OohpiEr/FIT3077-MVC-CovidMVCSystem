require_relative '../../../handler/booking_handler'

class SearchBookingController < ApplicationController
  
  def index
  end

  def search
    @booking = nil
    if params.key?(:pin_or_id)
      pin_or_id = params[:pin_or_id]
      bookingHandler = BookingHandler.getInstance
      if bookingHandler.isValidPIN(pin_or_id)
        @booking = bookingHandler.getBookingWithPIN(pin_or_id)
      elsif bookingHandler.isValidBookingID(pin_or_id)
        @booking = bookingHandler.getBooking(pin_or_id)
      else
        flash[:notice] = "Invalid PIN or ID!"
        redirect_to action: 'search'
        return
      end
      if @booking == nil
          flash[:notice] = "Booking doesn't exist!"
          redirect_to action: 'search'
      else
        redirect_to profile_show_path(@booking.id)
      end

    else
      render :search
    end
  end

end
