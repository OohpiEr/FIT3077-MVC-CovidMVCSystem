require_relative 'user'

class HealthcareWorker < User

    #
    # Constructor
    #
    # @param [String] id - The HealthcareWorker's ID
    # @param [String] givenName - The HealthcareWorker's given name
    # @param [String] familyName The HealthcareWorker's family name
    # @param [String] userName - The HealthcareWorker's user name
    # @param [String] phoneNumber - The HealthcareWorker's phone number
    # @param [Hash] additionalInfo - Additional info of the HealthcareWorker
    # @param [Array<Hash>] testsAdministered - A list of the tests administered by the HealthcareWorker as hashes
    #
    def initialize(id, givenName, familyName, userName, phoneNumber, additionalInfo, testsAdministered)
        super(id, givenName, familyName, userName, phoneNumber, additionalInfo)
        @testsAdministered = testsAdministered
        @userType = UserType::HealthcareWorker
        @testingSiteId = @additionalInfo[:testingSiteId]
    end

    attr_reader :testingSiteId
    
end