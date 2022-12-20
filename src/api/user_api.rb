require 'uri'
require 'net/http'
require 'json'
require_relative 'api'

# #
# A class that handles interactions with users in the api
class UserAPI < API

    @@USER_EXTENSION = "/user"
    @@PARAMETERS = "?fields[]=bookings&fields[]=bookings.covidTests&fields[]=testsTaken&fields[]=testsAdministered"
    @@instance = nil

    #
    # Returns an instance of the TestingSiteAPI class. Implements the Singleton design pattern. Should be used when trying to 
    # get a new instance of this class
    #
    # @return [TestingSiteAPI] - An instance of this class
    #
    def self.getInstance
        if !@@instance
            @@instance = self.new(@@ROOT_URL, @@API_KEY)
        end
        return @@instance
    end

    #
    # Makes a request to the API for all users. Users are returned as raw data from the API
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is as returned from the API 
    #
    def getUsersRaw
        extensions = @@USER_EXTENSION + @@PARAMETERS
        response = get(extensions)
        return {response: response, data: response.body}
    end

    #
    # Makes a request to the API for all users. Users are returned as a hash of user data
    #
    # @return [Hash] - A hash representing the response of the API request. Data in decoded into a hash 
    #
    def getUsers
        raw = getUsersRaw
        return {response: raw[:response], data: decode(raw[:data])}
    end

    #
    # Makes a request to the API to create a new user. Data in response is as returned from the API
    #
    # @param [Hash] data - Data for the new user to be created
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is as returned from the API 
    #
    def postUserRaw(data)
        extensions = @@USER_EXTENSION
        response = post(extensions, data)
        return {response: response, data: response.body}
    end

    #
    # Makes a request to the API to create a new user. Data in response is decoded into a hash
    #
    # @param [Hash] data - Data for the new user to be created
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is decoded into a hash
    #
    def postUser(data)
        raw = postUserRaw(data)
        return {response: raw[:response], data: decode(raw[:data])}
    end

    #
    # Makes a request to the API for a specific user using the provided id. Data in response is as returned from the API
    #
    # @param [String] id - ID of the user to be retrived
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is as returned from the API 
    #
    def getUserWithIdRaw(id)
        extensions = "#{@@USER_EXTENSION}/#{id}#{@@PARAMETERS}"
        response = get(extensions)
        return {response: response, data: response.body}
    end

    #
    # Makes a request to the API for a specific user using the provided id. Data in response is decoded into a hash
    #
    # @param [String] id - ID of the user to be retrived
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is decoded into a hash
    #
    def getUserWithId(id)
        raw = getUserWithIdRaw(id)
        return {response: raw[:response], data: decode(raw[:data])}
    end

    #
    # Makes a request to the API to replace a specific user using the provided id. Data in response is as returned from the API
    #
    # @param [String] id - ID of the user to be edited
    # @param [Hash] data - Data of the user that should be updated
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is as returned from the API 
    #
    def putUserRaw(id, data)
        extensions = "#{@@USER_EXTENSION}/#{id}"
        response = put(extensions, data)
        return {response: response, data: response.body}
    end

    #
    # Makes a request to the API to replace a specific user using the provided id. Data in response is decoded into a hash
    #
    # @param [String] id - ID of the user to be edited
    # @param [Hash] data - Data of the user that should be updated
    #
    # @return [Hash] - A hash representing the response of the API request. Data in response is decoded into a hash
    #
    def putUser(id, data)
        raw = putUserRaw(data)
        return {response: raw[:response], data: decode(raw[:data])}
    end

    #
    # Makes a request to the API to edit a specific user using the provided id. Data in response is as returned from the API
    #
    # @param [String] id - ID of the user to be edited
    # @param [Hash] data - Data of the user that should be updated
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is as returned from the API 
    #
    def patchUserRaw(id, data)
        extensions = "#{@@USER_EXTENSION}/#{id}"
        response = patch(extensions, data)
        return {response: response, data: response.body}
    end

    #
    # Makes a request to the API to edit a specific user using the provided id. Data in response is decoded into a hash
    #
    # @param [String] id - ID of the user to be edited
    # @param [Hash] data - Data of the user that should be updated
    #
    # @return [Hash] - A hash representing the response of the API request. Data in response is decoded into a hash 
    #
    def patchUser(id, data)
        raw = patchUserRaw(id, data)
        return {response: raw[:response], data: decode(raw[:data])}
    end

    #
    # Makes a requrest to the API to delete a specific user
    #
    # @param [String] id - ID of the user to be deleted
    #
    # @return [Hash] - A hash representing the response of the API request
    #
    def deleteUser(id)
        extensions = "#{@@USER_EXTENSION}/#{id}"
        response = delete(extensions)
        return {response: response}
    end

    #
    # Makes a request to the API to check if the provided login credentials are valid. Data in the response is as returned from the API 
    #
    # @param [Hash] details - Login details provided as a hash
    # @param [Boolean] returnJWT - Whether or not the API should return a JWT
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is as returned from the API 
    #
    def loginRaw(details, returnJWT)
        extensions = "#{@@USER_EXTENSION}/login"
        extensions += "?jwt=true" if returnJWT
        response = post(extensions, details)
        return {response: response, data: response.body}
    end

    #
    # Makes a request to the API to check if the provided login credentials are valid. Data in response is decoded into a hash 
    #
    # @param [Hash] details - Login details provided as a hash
    # @param [Boolean] returnJWT - Whether or not the API should return a JWT
    #
    # @return [Hash] - A hash representing the response of the API request. Data in response is decoded into a hash 
    #
    def login(details, returnJWT)
        raw = loginRaw(details, returnJWT)
        return {response: raw[:response], data: decode(raw[:data])}
    end

    #
    # Makes a requrest to the API to verify the validity of a JWT
    #
    # @param [String] jwt - The JWT to be validated
    #
    # @return [Hash] - A hash representing the response of the API request
    #
    def verifyToken(jwt)
        extensions = "#{@@USER_EXTENSION}/verify-token"
        data = {jwt: jwt}
        response = post(extensions, data)
        return {response: response}
    end
end