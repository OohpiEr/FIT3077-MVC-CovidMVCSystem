require_relative '../api/testing_site_api'
require_relative 'handler'
require_relative '../registration/testing_site'

# #
# A class that provides an interface for client code to interact with testing sites stored in the API
class TestingSiteHandler < Handler

    @@apiClass = TestingSiteAPI
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
    # Creates and returns a new Testing Site object given the testing site data
    #
    # @param [Hash] bookingData - The data of the Testing Site object to be created
    #
    # @return [Testing Site] - The new Testing Site object created
    #
    def createTestingSite(testingSiteData)
        testingSiteData = symbolizeNames(testingSiteData)
        return TestingSite.new(testingSiteData[:id], testingSiteData[:name], testingSiteData[:description], testingSiteData[:websiteUrl], testingSiteData[:phoneNumber], testingSiteData[:address], testingSiteData[:bookings], testingSiteData[:additionalInfo][:facilityTypes])
    end

    protected :createTestingSite

    #
    # Retrives a list of all available Testing Site objects
    #
    # @return [Array<Testing Site>] - A list of all available Testing Site objects
    #
    def getTestingSites
        testingSitesHash = @apiInstance.getTestingSites
        testingSitesData = testingSitesHash[:data]
        testingSites = []
        for testingSiteData in testingSitesData
            testingSites << createTestingSite(testingSiteData)
        end
        return testingSites
    end

    #
    # Retrives a Testing Site object with the specified ID
    #
    # @param [String] id - The ID of the testing site to be retrieved
    #
    # @return [Testing Site] - The Testing Site object with the specified ID
    #
    def getTestingSite(id)
        testingSiteData = @apiInstance.getTestingSiteWithId(id)[:data]
        if symbolizeNames(testingSiteData).include?(:id)
            return createTestingSite(testingSiteData)
        else
            return nil
        end
    end

    #
    # Returns a list of testing sites filtered by the provided suburb and facility types
    #
    # @param [String] suburb - The suburb name to filter by
    # @param [Array<TestingSiteType>] facilityTypes - The facility types to filter by
    #
    # @return [Array<TestingSite>] - An array of Testing Site objects filtered by the provided suburb and facility types
    #
    def filterTestingSites(suburb, facilityTypes)
        testingSites = getTestingSites()
        if suburb != "" and suburb
            testingSites = testingSites.select {|testingSite| testingSite.getAddress[:suburb].downcase == suburb.downcase}
        end
        for facilityType in facilityTypes
            testingSites = testingSites.select {|testingSite| testingSite.isType(facilityType)}
        end
        return testingSites
    end
end