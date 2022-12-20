require_relative 'user'

#
# Receptionist User Class
#
class Receptionist < User
    
    #
    # Constructor
    #
    # @param [String] id - The Receptionist's ID
    # @param [String] givenName - The Receptionist's given name
    # @param [String] familyName The Receptionist's family name
    # @param [String] userName - The Receptionist's user name
    # @param [String] phoneNumber - The Receptionist's phone number
    # @param [Hash] additionalInfo - Additional info of the Receptionist
    #
    def initialize(id, givenName, familyName, userName, phoneNumber, additionalInfo)
        super(id, givenName, familyName, userName, phoneNumber, additionalInfo)
        @userType = UserType::Receptionist
        @testingSiteId = @additionalInfo[:testingSiteId]
    end

    attr_reader :testingSiteId

end