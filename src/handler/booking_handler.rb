require_relative '../api/booking_api'
require_relative 'handler'
require_relative '../registration/booking'
require_relative '../registration/bookingCaretaker'
require 'time'


# #
# A class that provides an interface for client code to interact with bookings stored in the API
class BookingHandler < Handler

    @@apiClass = BookingAPI
    @@instance = nil

    #
    # Returns an instance of the BookingHandler class. Implements the Singleton design pattern. Should be used when trying to 
    # get a new instance of this class
    #
    # @return [BookingHandler] - An instance of this class
    #
    def self.getInstance
        if !@@instance
            @@instance = self.new
        end
        return @@instance
    end

    #
    # Contructor
    #
    def initialize
        @apiInstance = @@apiClass.getInstance
    end
    
    #
    # Patches the booking information in the API
    #
    # @param [String] id - The booking's ID
    # @param [Hash] newData - The updated attributes with their new values
    #
    def patchBooking(id, newData)
        @apiInstance.patchBooking(id, newData)
    end
    
    #
    # Checks if the booking has lapsed and updates its status accordingly
    #
    # @param [Booking] booking - The booking to check/update
    #
    def checkBookingLapsed(booking)
        if booking.checkLapsed
            patchBooking(booking.id, {status: booking.status})
        end
    end

    #
    # Creates and returns a new Booking object given the booking data
    #
    # @param [Hash] bookingData - The data of the Booking object to be created
    #
    # @return [Booking] - The new Booking object created
    #
    def createBooking(bookingData)
        bookingData = symbolizeNames(bookingData)
        
        timedata = [bookingData[:createdAt], bookingData[:updatedAt], bookingData[:startTime]]

        timedata.each_with_index do |time, i|
            if not time.is_a? Time
                timedata[i] = Time.parse(time)
            end
        end

        booking = Booking.new(bookingData[:id], bookingData[:customer], bookingData[:testingSite], timedata[0], timedata[1], timedata[2], bookingData[:smsPin], bookingData[:status], bookingData[:covidTests], bookingData[:notes], bookingData[:additionalInfo])
        checkBookingLapsed(booking)
        return booking
    end

    protected :createBooking

    #
    # Retrives a list of all available Booking objects
    #
    # @return [Array<Booking>] - A list of all available Booking objects
    #
    def getBookings
        bookings = @apiInstance.getBookings[:data].map {|bookingData| createBooking(bookingData)}
        return bookings
    end

    #
    # Retrives a Booking object with the specified ID
    #
    # @param [String] id - The ID of the booking to be retrieved
    #
    # @return [Booking] - The Booking object with the specified ID
    #
    def getBooking(id)
        booking = nil
        response = @apiInstance.getBookingWithId(id)
        if response[:response].is_a? Net::HTTPSuccess
            bookingData = response[:data]
            booking = createBooking(bookingData)
        end

        return booking
    end

    #
    # Retrieves a Booking object with the specified PIN
    #
    # @param [String] pin - The PIN of the booking to be retrieved
    #
    # @return [Booking] - The Booking object with the specified PIN
    #
    def getBookingWithPIN(pin)
        booking = getBookings.find {|booking| booking.smsPin == pin}
        return booking
    end

    #
    # Verifies whether the provided PIN is a valid booking PIN
    #
    # @param [String] pin - The PIN to be validated
    #
    # @return [Boolean] - Whether the PIN is valid
    #
    def isValidPIN(pin)
        valid = pin.size == 6 && Integer(pin) != nil
        return valid
    end

    #
    # Verifies whether the provided booking id is a valid booking id
    #
    # @param [String] id - The booking id to be validated
    #
    # @return [Boolean] - Whether the booking id is valid
    #
    def isValidBookingID(id)
        valid = id.size == 36
        return valid
    end

    #
    # adds a new booking to the api 
    #
    # @param [<string>] customerId 
    # @param [<string>] testingSiteId 
    # @param [<string>] startTime ISO 8601 date string
    # @param [<string>] notes 
    # @param [<*string>] *additionalInfo if not empty is home booking, first parameter is whether patient already has testkit
    #
    # @return [<Booking>] a Booking object
    #
    def addBooking(customerId, testingSiteId, startTime, notes, *additionalInfo)
        bookingInfo = { 
            customerId: customerId,
        }
        if startTime.is_a? Time
            bookingInfo[:startTime] = startTime.utc.iso8601
        else
            bookingInfo[:startTime] = startTime
        end
            

        additionalInfoHash = {}
        
        if testingSiteId != "" || testingSiteId == nil
            bookingInfo[:testingSiteId] = testingSiteId
        end
        
        if notes != "" || notes == nil
            bookingInfo[:notes] = notes
        end
        
        if !additionalInfo.empty?
            additionalInfoHash[:has_testkit] = additionalInfo[0]
            additionalInfoHash[:qr_code] = Booking.generateQRCode
            additionalInfoHash[:url] = Booking.generateUrl
            bookingInfo[:additionalInfo] = additionalInfoHash
        end

        booking = createBooking(@apiInstance.postBooking(bookingInfo)[:data])
        return booking
    end
    
    #
    # Adds the specified covid test recommendation to the booking with the specified PIN
    #
    # @param [String] smsPin - The PIN of the booking to be modified
    # @param [CovidTestType] covidTest - The recommended covid test type
    #
    def addTestRecommendationPin(smsPin, covidTest)
        booking = getBookingWithPIN(smsPin)
        addTestRecommendation(booking, covidTest)
    end

    #
    # Adds the specidied covid test recommendation to the supplied Booking object
    #
    # @param [Booking] booking - The Booking that the covid test is recommended for
    # @param [CovidTestType] covidTest - The recommended covid test type
    #
    def addTestRecommendation(booking, covidTest)
        booking.addTestRecommendation(covidTest)
        patchBooking(booking.id, {additionalInfo: booking.additionalInfo, status: booking.status})
    end

    #
    # Retrieves a Booking object with the specified QR code
    #
    # @param [String] qrCode - The QR code of the booking to be retrieved
    #
    # @return [Booking] - The Booking object with the specified PIN
    #
    def getBookingWithQrCode(qrCode)
        bookings = getBookings.find_all {|booking| booking.getQrCode == qrCode}
        return bookings
    end

    #
    # Adds a covid test to the provided booking
    #
    # @param [Booking] booking - The booking to add the test to
    # @param [CovidTestType] covidTestType - The type of covid test to add to the booking
    #
    def addCovidTest(booking, covidTestType)
        booking.addCovidTest(covidTestType)
        patchBooking(booking.id, {additionalInfo: booking.additionalInfo, status: booking.status})
    end

    #
    # Deletes a Booking object with the specified ID
    #
    # @param [String] id - The ID of the booking to be deleted
    #
    # @return [Hash] response - The result of the request. response[:success] will be true or false. response[:details] will provide further details
    #
    def deleteBooking(id)
        output = {}

        response = @apiInstance.deleteBooking(id)[:response]
        if response.is_a? Net::HTTPSuccess
            output[:success] = true
            output[:details] = 'Booking was successfully deleted'
        else
            output[:success] = false
            output[:details] = eval(response.body)[:message]
        end

        return output
    
    end

    #
    # Attempts to cancel a booking
    #
    # @param [String] id - The ID of the booking to be cancelled
    #
    # @return [Hash] - The result of the request. response[:success] will be true or false. response[:details] will provide further details
    #
    def cancelBooking(id)

        booking = getBooking(id)
        response = booking.cancel
        if response[:success]
            @apiInstance.patchBooking(booking.id, {status: booking.status})
        end
        return response

    end

    #
    # Calls Booking caretaker to save modified bookings
    #
    # @param [string] bookingId booking id
    # @param [hash] data data to be modifiedAt
    #
    def modifyBooking(bookingId, data)
        booking = getBooking(bookingId)

        caretaker = BookingCaretaker.new(booking)
        caretaker.save

        data[:additionalInfo] = booking.additionalInfo
        patchBooking(bookingId, data)
    end

    
    #
    # Calls Booking Caretaker to undo a booking 
    #
    # @param [string] bookingId booking id
    #
    # @return [boolean] whether undo was successful
    #
    def undoBooking(bookingId)
        booking = getBooking(bookingId)
        return false if not (booking.additionalInfo[:mementos] or booking.additionalInfo[:undoCount])
        
        if booking.additionalInfo[:undoCount] < 3 and ![BookingStatus::Cancelled, BookingStatus::Lapsed].include? booking.status 
            caretaker = BookingCaretaker.new(booking)
            caretaker.undo
            
            data = {testingSiteId: booking.testingSiteData[:id],
                    startTime: booking.startTime,
                    additionalInfo: booking.additionalInfo}
            patchBooking(bookingId, data)
            return true
        else
            return false
        end
    end

    #
    # Prints booking and additional info to output
    #
    # @param [Booking] booking Booking object
    #
    def putsBooking(booking)
        # print
        puts "STARTTIME #{booking.startTime}"
        puts "ID #{booking.testingSiteData[:id]}"
        puts "ADDITIONALINFO ------------------------------------------------------------"
        puts "               undoCount: #{m[:undoCount]}"
        booking.additionalInfo[:mementos].each do |m|
            puts "               ------------------------------------------------------------"
            puts "               Testing site: #{m[:testingSiteData][:id]}"
            puts "               Starttime: #{m[:startTime]}"
            puts "               modifiedAt: #{m[:modifiedAt]}"
        end
        puts "================================================================"
    end
end