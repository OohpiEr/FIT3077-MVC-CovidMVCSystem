require_relative '../user_interface/html_util'
require_relative 'testing_site'
require_relative 'booking_concrete_memento'
require_relative '../user/customer'
require_relative 'booking_status'

# #
# A class representing a booking
class Booking

    #
    # Constructor
    #
    # @param [String] id - The booking's ID
    # @param [Hash] customerData - The booking's customer's data
    # @param [Hash] testingSiteData - The booking's testing site's data
    # @param [String] createdAt - The date and time the booking was created
    # @param [String] updatedAt - The date and time the booking was last updated
    # @param [String] startTime - The date and time the booking is registered for
    # @param [String] smsPin - The sms PIN sent to the user to help identify the booking
    # @param [String] status - The status of the booking
    # @param [Array<Hash>] covidTests - A list of hashes representing covid tests that are part of the booking
    # @param [String] notes - Extra notes for the booking
    # @param [Hash] additionalInfo - Additional info for the booking
    #
    def initialize(id, customerData, testingSiteData, createdAt, updatedAt, startTime, smsPin, status, covidTests, notes, additionalInfo)
        @id = id
        @customer = customerData
        @testingSiteData = testingSiteData
        @createdAt = createdAt
        @updatedAt = updatedAt
        @startTime = startTime
        @smsPin = smsPin
        @status = status
        @covidTests = covidTests
        @notes = notes
        @additionalInfo = additionalInfo
        @state = {:testingSiteData => @testingSiteData, :startTime => @startTime, :modifiedAt => nil}
    end

    # private getter/settor for state
    attr_accessor :state
    private :state
    
    # public getters
    attr_reader :id
    attr_reader :smsPin
    attr_reader :status
    attr_reader :covidTests
    attr_reader :notes
    attr_reader :customer
    
    # public getter/settor
    attr_accessor :additionalInfo
    attr_accessor :testingSiteData
    attr_accessor :updatedAt
    attr_accessor :startTime

    #
    # Getter for testing site ID
    #
    # @return [string] testing site ID
    #
    def getTestingSiteId
        if @testingSiteData
            return @testingSiteData[:id]
        else
            return nil
        end
    end

    #
    # Attempts to cancel a booking
    #
    # @return [Hash] - The result of the request. response[:success] will be true or false. response[:details] will provide further details
    #
    def cancel    
        response = {}

        if @status == BookingStatus::Lapsed or @status == BookingStatus::Cancelled
            response[:success] = false
            response[:details] = "Booking already #{@status.downcase}"
        else
            @status = BookingStatus::Cancelled
            response[:success] = true
            response[:details] = 'Booking successfully cancelled'
        end

        return response
    end

    #
    # Check if the booking has lapsed, and updates its status accordingly
    #
    # @return [Boolean] Whether the booking's status was updated
    #
    def checkLapsed
        if @startTime < Time.now.utc and ![BookingStatus::Cancelled, BookingStatus::Lapsed].include?(@status)
            @status = BookingStatus::Lapsed
            return true
        else
            return false
        end
    end

    #
    # Adds a test recommendation to the booking in additional info
    #
    # @param [CovidTestType] covidTest - The type of covid test recommended for the booking
    #
    def addTestRecommendation(covidTest)
        @additionalInfo[:recommendation] = covidTest
        @status = BookingStatus::Processed
    end

    #
    # Generates a randomised QR code for a booking
    #
    # @return [String] - A string representation of the generated QR code
    #
    def self.generateQRCode
        string_length = 20
        return rand(36**string_length).to_s(36)     
    end
    
    #
    # Generates a randomised URL for a booking
    #
    # @return [String] - The generated URL
    #
    def self.generateUrl
        string_length = 20
        return rand(36**string_length).to_s(36)
    end

    #
    # Returns the Qr Code for a booking
    #
    # @return [String] Qr Code for the booking
    #
    def getQrCode
        return @additionalInfo[:qr_code]
    end
    
    #
    # Sends the url of the booking (currently a dummy method)
    #
    # @return [String] - The URL sent
    #
    def sendUrl
        # supposed to send the url
        # right now it just returns the url
        return @additionalInfo[:url]
    end

    #
    # Adds a covid test to the booking
    #
    # @param [CovidTestType] covidTestType - The type of covid test to add to the booking
    #
    #
    def addCovidTest(covidTestType)
        @additionalInfo[:covid_test_booked] = covidTestType
        @status = BookingStatus::Processed
    end
    
    #
    # Creates a new memento bookmark
    #
    # @param [hash] state state of booking object
    #
    # @return [BookingConcreteMemento] memento
    #
    def getMemento(state)
        return BookingConcreteMemento.new(state)
    end
    
    #
    # Creates a memento and saves current state of booking objects
    #
    # @param [hash] state state of booking object
    #
    # @return [BookingConcreteMemento] memento
    #
    def save(state = @state)
        # create new Memento & save it
        state[:modifiedAt] = Time.now.utc.iso8601

        if additionalInfo[:mementos] == nil
            additionalInfo[:mementos] = [@state]
        else
            @additionalInfo[:mementos] << @state
        end

        return BookingConcreteMemento.new(state)
    end
    
    
    #
    # Restores booking object to state saved in memento
    #
    # @param [BookingConcreteMemento] bookingMemento memento
    #
    def restore(bookingMemento)
        @state = bookingMemento.state

        @testingSiteData = state[:testingSiteData]
        @startTime = Time.parse(state[:startTime])
    end

end