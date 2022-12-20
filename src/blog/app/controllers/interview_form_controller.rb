require_relative '../../../handler/booking_handler'
require_relative '../../../covid_test/covid_test_type'
require_relative 'booking_updater'


#
# Controller for interview form 
#
class InterviewFormController < ApplicationController

  include BookingUpdater

  def index
  end

  #
  # controller for form submissions. Calculates the score and renders the view.
  #
  def submit
    @score = 0
    @temp = params
    if params["has_sore_throat"] == "1"
      @score += 1
    end
    if params["has_cough"] == "1"
      @score += 1
    end
    if params["has_fever"] == "1"
      @score += 1
    end
    if params["difficulty_breathing"] == "1"
      @score += 1
    end
    if params["close_contact"] == "1"
      @score += 1
    end

    if @score >= 3
      result = CovidTestType::PCR
    elsif @score >= 1
      result = CovidTestType::RAT
    else
      result = "No covid test needed"
    end
    @result = result

    bookingHandler = BookingHandler.getInstance
    if !bookingHandler.isValidPIN(params[:sms_pin])
      flash.now[:notice] = "Invalid PIN!"
      render :submit
    else
      booking = bookingHandler.getBookingWithPIN(params[:sms_pin])
      if booking == nil
        flash.now[:notice] = "Booking doesn't exist!"
        render :submit
      else
        bookingHandler.addTestRecommendationPin(params[:sms_pin], result)
        flash.now[:notice] = "Recommendation added to booking with PIN: #{params[:sms_pin]}"
        bookingUpdated(booking.id, "Covid Test Recommendation Updated", [booking.getTestingSiteId])
        render :submit
      end
    end

  end
  
end
