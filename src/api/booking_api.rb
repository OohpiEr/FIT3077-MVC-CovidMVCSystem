require 'uri'
require 'net/http'
require 'json'
require_relative 'api'

# #
# A class that handles interactions with bookings in the api
class BookingAPI < API

    @@BOOKING_EXTENSION = "/booking"
    @@instance = nil

    #
    # Returns an instance of the BookingAPI class. Implements the Singleton design pattern. Should be used when trying to 
    # get a new instance of this class
    #
    # @return [BookingAPI] - An instance of this class
    #
    def self.getInstance
        if !@@instance
            @@instance = self.new(@@ROOT_URL, @@API_KEY)
        end
        return @@instance
    end

    #
    # Makes a request to the API for all bookings. Bookings are returned as raw data from the API
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is as returned from the API 
    #
    def getBookingsRaw
        extensions = @@BOOKING_EXTENSION
        response = get(extensions)
        return {response: response, data: response.body}
    end

    #
    # Makes a request to the API for all bookings. Bookings are returned as a hash of booking data
    #
    # @return [Hash] - A hash representing the response of the API request. Data in decoded into a hash 
    #
    def getBookings
        raw = getBookingsRaw
        return {response: raw[:response], data: decode(raw[:data])}
    end

    #
    # Makes a request to the API to create a new booking. Data in response is as returned from the API
    #
    # @param [Hash] data - Data for the new booking to be created
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is as returned from the API 
    #
    def postBookingRaw(data)
        extensions = @@BOOKING_EXTENSION
        response = post(extensions, data)
        return {response: response, data: response.body}
    end

    #
    # Makes a request to the API to create a new booking. Data in response is decoded into a hash
    #
    # @param [Hash] data - Data for the new booking to be created
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is decoded into a hash
    #
    def postBooking(data)
        raw = postBookingRaw(data)
        return {response: raw[:response], data: decode(raw[:data])}
    end

    #
    # Makes a request to the API for a specific booking using the provided id. Data in response is as returned from the API
    #
    # @param [String] id - ID of the booking to be retrived
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is as returned from the API 
    #
    def getBookingWithIdRaw(id)
        extensions = "#{@@BOOKING_EXTENSION}/#{id}"
        response = get(extensions)
        return {response: response, data: response.body}
    end

    #
    # Makes a request to the API for a specific booking using the provided id. Data in response is decoded into a hash
    #
    # @param [String] id - ID of the booking to be retrived
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is decoded into a hash
    #
    def getBookingWithId(id)
        raw = getBookingWithIdRaw(id)
        return {response: raw[:response], data: decode(raw[:data])}
    end

    #
    # Makes a request to the API to edit a specific booking using the provided id. Data in response is as returned from the API
    #
    # @param [String] id - ID of the booking to be edited
    # @param [Hash] data - Data of the booking that should be updated
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is as returned from the API 
    #
    def patchBookingRaw(id, data)
        extensions = "#{@@BOOKING_EXTENSION}/#{id}"
        response = patch(extensions, data)
        return {response: response, data: response.body}
    end

    #
    # Makes a request to the API to edit a specific booking using the provided id. Data in response is decoded into a hash
    #
    # @param [String] id - ID of the booking to be edited
    # @param [Hash] data - Data of the booking that should be updated
    #
    # @return [Hash] - A hash representing the response of the API request. Data in response is decoded into a hash 
    #
    def patchBooking(id, data)
        raw = patchBookingRaw(id, data)
        return {response: raw[:response], data: decode(raw[:data])}
    end

    #
    # Makes a requres to the API to delete a specific booking
    #
    # @param [String] id - ID of the booking to be deleted
    #
    # @return [Hash] - A hash representing the response of the API request
    #
    def deleteBooking(id)
        extensions = "#{@@BOOKING_EXTENSION}/#{id}"
        response = delete(extensions)
        return {response: response}
    end
end