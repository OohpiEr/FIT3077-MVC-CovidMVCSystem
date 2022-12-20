require_relative '../../../handler/package'
require_relative '../../../registration/package'
require_relative '../../../user/package'

class TestingSiteBookingsController < ApplicationController

  include BookingUpdater

  def index
    user = UserHandler.getInstance.getUserWithJWT(session[:current_user_jwt])
    checkIsAdmin(user)

    testingSiteId = user.testingSiteId
    testingSite = TestingSiteHandler.getInstance.getTestingSite(testingSiteId)
    @bookings = testingSite.bookings.map{ |booking| BookingHandler.getInstance.getBooking(booking.id)}

  end

  def delete
    bookingId = params[:bookingId]
    booking = BookingHandler.getInstance.getBooking(bookingId)
    response = BookingHandler.getInstance.deleteBooking(bookingId)
    flash[:notice] = response[:details]

    if response[:success]
      bookingUpdated(booking.id, "Booking Deleted", booking.getTestingSiteId)
    end

    redirect_back fallback_location: testing_site_bookings_index_path
  end

  def cancel
    bookingId = params[:bookingId]
    booking = BookingHandler.getInstance.getBooking(bookingId)
    response = BookingHandler.getInstance.cancelBooking(bookingId)
    flash[:notice] = response[:details]

    if response[:success]
      bookingUpdated(booking.id, "Booking Cancelled", booking.getTestingSiteId)
    end

    redirect_back fallback_location: testing_site_bookings_index_path
  end

  def checkIsAdmin(user)
    if not user.userType == UserType::Receptionist
      flash[:notice] = "You're not an admin."
      redirect_to home_index_url
    end 
  end

end
