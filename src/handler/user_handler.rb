require_relative '../api/user_api'
require_relative 'handler'
require 'base64'
require_relative '../user/user'
require_relative '../user/user_factory'
require 'net/http'

# #
# A class that provides an interface for client code to interact with bookings stored in the API
class UserHandler < Handler

    @@apiClass = UserAPI
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
    # Creates and returns a new User object given the user data
    #
    # @param [Hash] bookingData - The data of the User object to be created
    #
    # @return [User] - The new User object created
    #
    def createUser(userData)
        userData = symbolizeNames(userData)
        return UserFactory.getUser(userData)
    end

    protected :createUser

    #
    # Retrives a list of all available User objects
    #
    # @return [Array<User>] - A list of all available User objects
    #
    def getUsers
        users = @apiInstance.getUsers[:data].map {|userData| createUser(userData)}
        return users
    end

    #
    # Retrives a User object with the specified ID
    #
    # @param [String] id - The ID of the user to be retrieved
    #
    # @return [User] - The User object with the specified ID
    #
    def getUser(id)
        userData = @apiInstance.getUserWithId(id)[:data]
        return createUser(userData)
    end

    #
    # Retrieves a User object with the specified JWT
    #
    # @param [String] jwt - The JWT with the data of the user to be retrieved
    #
    # @return [User] - The User object with the specified JWT
    #
    def getUserWithJWT(jwt)
        if (@apiInstance.verifyToken(jwt))[:response].is_a? Net::HTTPSuccess
            userId = symbolizeNames(@apiInstance.decodeJWT(jwt))[:sub]
            return getUser(userId)
        else
            return nil
        end
    end

    #
    # Retrieves a User object with the specified username
    #
    # @param [String] username - The username of the user to be retrieved
    #
    # @return [User] - The User object with the specified username
    #
    def getUserWithUsername(username)
        user = getUsers.find {|user| user.getUsername == username}
        return user
    end

    #
    # Returns the result of a login attempt with the provided credentials
    #
    # @param [String] username - The username of the user
    # @param [String] password - The password of the user
    # @param [Boolean] returnJWT - Whether or not to return a JWT as part of the response
    #
    # @return [Hash] - A hash containing the successfulness of the login and any additional data
    #
    def login(username, password, returnJWT)
        details = {userName: username, password: password}
        response = @apiInstance.login(details, returnJWT)
        success = false
        if response[:response].is_a? Net::HTTPSuccess
            success = true
        end
        return {success: success, data: symbolizeNames(response[:data])}
    end
end

handler = UserHandler.getInstance