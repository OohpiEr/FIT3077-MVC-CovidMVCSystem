require_relative 'user'
require_relative 'user_type'

# #
# A class representing a Customer
class Customer < User

    #
    # Constructor
    #
    # @param [String] id - The Customer's ID
    # @param [String] givenName - The Customer's given name
    # @param [String] familyName The Customer's family name
    # @param [String] userName - The Customer's user name
    # @param [String] phoneNumber - The Customer's phone number
    # @param [Array<Hash>] bookingsData - A list of the Customer's bookings as hashes
    # @param [Hash] additionalInfo - Additional info of the Customer
    # @param [Array<Hash>] testsTaken - A list of the tests taken by the Customer as hashes
    #
    def initialize(id, givenName, familyName, userName, phoneNumber, bookingsData, additionalInfo, testsTaken)
        super(id, givenName, familyName, userName, phoneNumber, additionalInfo)
        @bookings = bookingsData.map { |bookingData| Booking.new(bookingData[:id], bookingData[:customer], nil, bookingData[:createdAt], bookingData[:updatedAt], bookingData[:startTime], bookingData[:smsPin], bookingData[:status], bookingData[:covidTests], bookingData[:notes], bookingData[:additionalInfo])}
        @testsTaken = testsTaken
        # @bookings = 
        @userType = UserType::Customer
    end

end