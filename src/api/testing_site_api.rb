require 'uri'
require 'net/http'
require 'json'
require_relative 'api'

# #
# A class that handles interactions with testing sites in the api
class TestingSiteAPI < API

    @@TESTING_SITE_EXTENSION = "/testing-site"
    @@PARAMETERS = "?fields[]=bookings&fields[]=bookings.covidTests"
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
    # Makes a request to the API for all testing sites. Testing sites are returned as raw data from the API
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is as returned from the API 
    #
    def getTestingSitesRaw
        extensions = "#{@@TESTING_SITE_EXTENSION}#{@@PARAMETERS}"
        response = get(extensions)
        return {response: response, data: response.body}
    end

    #
    # Makes a request to the API for all testing sites. Testing sites are returned as a hash of testing site data
    #
    # @return [Hash] - A hash representing the response of the API request. Data in decoded into a hash 
    #
    def getTestingSites
        raw = getTestingSitesRaw
        return {response: raw[:response], data: decode(raw[:data])}
    end

    #
    # Makes a request to the API to create a new testing site. Data in response is as returned from the API
    #
    # @param [Hash] data - Data for the new testing site to be created
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is as returned from the API 
    #
    def postTestingSiteRaw(data)
        extensions = @@TESTING_SITE_EXTENSION
        response = post(extensions, data)
        return {response: response, data: response.body}
    end

    #
    # Makes a request to the API to create a new testing site. Data in response is decoded into a hash
    #
    # @param [Hash] data - Data for the new testing site to be created
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is decoded into a hash
    #
    def postTestingSite(data)
        raw = postTestingSiteRaw(data)
        return {response: raw[:response], data: decode(raw[:data])}
    end

    #
    # Makes a request to the API for a specific testing site using the provided id. Data in response is as returned from the API
    #
    # @param [String] id - ID of the testing site to be retrived
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is as returned from the API 
    #
    def getTestingSiteWithIdRaw(id)
        extensions = "#{@@TESTING_SITE_EXTENSION}/#{id}#{@@PARAMETERS}"
        response = get(extensions)
        return {response: response, data: response.body}
    end

    #
    # Makes a request to the API for a specific testing site using the provided id. Data in response is decoded into a hash
    #
    # @param [String] id - ID of the testing site to be retrived
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is decoded into a hash
    #
    def getTestingSiteWithId(id)
        raw = getTestingSiteWithIdRaw(id)
        return {response: raw[:response], data: decode(raw[:data])}
    end

    #
    # Makes a request to the API to edit a specific testing site using the provided id. Data in response is as returned from the API
    #
    # @param [String] id - ID of the testing site to be edited
    # @param [Hash] data - Data of the testing site that should be updated
    #
    # @return [Hash] - A hash representing the response of the API request. Data in the response is as returned from the API 
    #
    def patchTestingSiteRaw(id, data)
        extensions = "#{@@TESTING_SITE_EXTENSION}/#{id}"
        response = patch(extensions, data)
        return {response: response, data: response.body}
    end

    #
    # Makes a request to the API to edit a specific testing site using the provided id. Data in response is decoded into a hash
    #
    # @param [String] id - ID of the testing site to be edited
    # @param [Hash] data - Data of the testing site that should be updated
    #
    # @return [Hash] - A hash representing the response of the API request. Data in response is decoded into a hash 
    #
    def patchTestingSite(id, data)
        raw = patchTestingSiteRaw(id, data)
        return {response: raw[:response], data: decode(raw[:data])}
    end

    #
    # Makes a requres to the API to delete a specific testing site
    #
    # @param [String] id - ID of the testing site to be deleted
    #
    # @return [Hash] - A hash representing the response of the API request
    #
    def deleteTestingSite(id)
        extensions = "#{@@TESTING_SITE_EXTENSION}/#{id}"
        response = delete(extensions)
        return {response: response}
    end
end