#
# Abstract User class
#
class User
    
    #
    # Constructor
    #
    # @param [String] id - The User's ID
    # @param [String] givenName - The User's given name
    # @param [String] familyName The User's family name
    # @param [String] userName - The User's user name
    # @param [String] phoneNumber - The User's phone number
    # @param [Hash] additionalInfo - Additional info of the User
    #
    def initialize(id, givenName, familyName, userName, phoneNumber, additionalInfo)
        @id = id
        @givenName = givenName
        @familyName = familyName
        @userName = userName
        @phoneNumber = phoneNumber
        @additionalInfo = additionalInfo
        @userType = nil
        if self.class == User
            raise "This is an abstract class. It shouldn't be instantiated"
        end
    end

    # Getters
    attr_reader :id
    attr_reader :userType
    
    # Getter for id
    def getId
        return @id
    end

    #
    # Getter for userName
    #
    # @return [String] The user's username
    #
    def getUsername
        return @userName
    end

    #
    # Returns the information of the user in HTML format
    #
    # @return [String] - The information of the user in HTML format
    #
    def toHTML
        return "User ID: #{@id}<br>
                Name: #{@givenName} #{@familyName}<br>
                Username: #{@userName}<br>
                Phone Number: #{@phoneNumber}<br>"
    end
    
end