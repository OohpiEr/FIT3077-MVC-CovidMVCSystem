require_relative '../user_interface/html_util'
require_relative 'booking'
require_relative '../handler/booking_handler'

#
# Testing Site  Class
#
class TestingSite

    @@WAITING_TIME_PER_BOOKING = 0.5    # in hours

    #
    # Constructor
    #
    # @param [String] id - The Testing Site's ID
    # @param [String] name - The Testing Site's name
    # @param [String] description - The Testing Site's description
    # @param [String] websiteUrl - The Testing Site's website url
    # @param [String] phoneNumber - The Testing Site's phone number
    # @param [Hash] address - The Testing Site's address
    # @param [Array<Hash>] bookings - The Testing Site's bookings as a Hash 
    # @param [Array<TestingSiteType>] facilityTypes - The Testing Site's facility types
    #
    def initialize(id, name, description, websiteUrl, phoneNumber, address, bookingsData, facilityTypes)
        @id = id
        @name = name
        @description = description
        @websiteUrl = websiteUrl
        @phoneNumber = phoneNumber
        @address = address
        @bookings = bookingsData.map { |bookingData| Booking.new(bookingData[:id], bookingData[:customer], nil, bookingData[:createdAt], bookingData[:updatedAt], bookingData[:startTime], bookingData[:smsPin], bookingData[:status], bookingData[:covidTests], bookingData[:notes], bookingData[:additionalInfo])}
        @facilityTypes = facilityTypes
        @waitingTime = bookings.size*@@WAITING_TIME_PER_BOOKING
    end

    # public getters
    attr_reader :bookings
    attr_reader :id

    #
    # Returns the information of the testing site in HTML format
    #
    # @return [String] - The information of the testing site in HTML format
    #
    def toHTML
        output = "ID: #{@id}<br>
                Name: #{@name}<br>
                Description: #{@description}<br>
                Website URL: #{@websiteUrl}<br>
                Phone Number: #{@phoneNumber}<br>
                Address:<br>
                #{HTMLUtil.getHTMLFromHash(@address)}<br>
                Facility Type: <br>"
        
        for type in @facilityTypes
            output += "#{type} <br>"
        end

        output += "Estimated Waiting Time: #{@waitingTime} hours<br>"
        output += "<hr>"
        return output

    end

    #
    # Returns whether the testing site is of the provided type
    #
    # @param [TestingSiteType] facilityType - The provided testing site type
    #
    # @return [Boolean] - Whether the testing site is of the provided type
    #
    def isType(facilityType)
        return @facilityTypes.include?(facilityType)
    end

    #
    # Getter for addres
    #
    # @return [Hash] The testing site's address
    #
    def getAddress
        return @address
    end

    #
    # Getter for name
    #
    # @return [String] Testing Site's name
    #
    def getName
        return @name
    end

    #
    # Getter for description
    #
    # @return [String] The Testing Site's description
    #
    def getDescription
        return @description
    end

    #
    # Getter for website url
    #
    # @return [String] The Testing Site's website url
    #
    def getWebsiteURL
        return @websiteUrl
    end

    #
    # Getter for phoneNumber
    #
    # @return [String] The Testing Site's phone number
    #
    def getPhoneNumber
        return @phoneNumber
    end

end