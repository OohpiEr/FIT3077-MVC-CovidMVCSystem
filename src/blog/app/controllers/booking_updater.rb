module BookingUpdater
    
    def bookingUpdated(bookingId, message, testingSiteIds)
        message = "Booking ID: #{bookingId}\n#{message}"
        ActionCable.server.broadcast('bookings_channel', {message: message, testingSiteIds: testingSiteIds})
    end

end