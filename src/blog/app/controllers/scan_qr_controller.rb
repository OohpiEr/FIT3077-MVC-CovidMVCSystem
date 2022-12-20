require_relative '../../../handler/booking_handler'
require_relative '../../../registration/booking'
require_relative '../../../covid_test/covid_test_type'


#
# Controller for scan qr
#
class ScanQrController < ApplicationController
  
    def index; end

    #
    # Controller for scan_qr/scan_qr
    #
    def scan_qr
        bookingHandler = BookingHandler.getInstance
        bookings = bookingHandler.getBookingWithQrCode(params[:qr_code])

        if bookings.empty?
            @booking = "booking does not exist"
        elsif bookings.length > 1
            @booking = "error: more than one @booking exist (num: #{bookings.length})"
        else
            @booking = bookings[0].id
            booking = bookingHandler.getBooking(bookings[0].id)
            bookingHandler.addCovidTest(booking, CovidTestType::RAT)
        
            @url = booking.sendUrl
        end

        render :scan_qr
    end
end
