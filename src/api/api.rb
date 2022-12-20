require 'uri'
require 'net/http'
require 'json'
require 'base64'

##
# Base API class. Includes basic get, post, patch etc. methods
class API

    @@ROOT_URL = "https://fit3077.com/api/v2"
    @@API_KEY = File.open("../../api_key.txt").read


    @rootUrl = ""
    @apiKey = ""

    # #
    # Constructor
    #
    # @param [String] url - The root url of the API
    # @param [String] apiKey - The API key used to authorize access
    #
    def initialize(url, apiKey)
        @rootUrl = url
        @apiKey = apiKey
    end

    # #
    # Encodes a hash into the API's chosen encoding format (currently JSON)
    #
    # @param [Hash] hash - The hash to encode
    #
    # @return [String] - The hash encoded into the API's chosen encoding format (currently JSON)
    #
    def encode(hash)
        return hash.to_json
    end

    protected :encode

    # #
    # Decodes an input from the API's chosen encoding format (currently JSON) into a hash
    #
    # @param [String] input - The JSON String to be decoded
    #
    # @return [Hash] - The hash extracted from the input
    #
    def decode(input)
        output = JSON.parse(input, serialize_names: true)
        return output
    end

    protected :decode

    # #
    # Decodes a provided JWT
    #
    # @param [String] jwt - A JSON Web Token to be decoded
    #
    # @return [Array<Hash>] - The decoded jwt's values
    #
    def decodeJWT(jwt)
        return decode(Base64.decode64(jwt.split('.')[1]))
    end

    # #
    # Makes a GET request to the API
    #
    # @param [String] extensions - The extentions to be added to the root url
    #
    # @return [Hash] The response from the API request
    #
    def get(extensions)
        url = @rootUrl + extensions
        uri = URI.parse(url)
        req = Net::HTTP::Get.new(uri)
        req['Authorization'] = @apiKey

        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') {|http|
            http.request(req)
        }

        return res
    end

    protected :get

    # #
    # Makes a POST request to the API
    #
    # @param [String] extensions - The extentions to be added to the root url
    # @param [Hash] data - The data to be supplied to the POST request
    #
    # @return [Hash] The response from the API request
    #
    def post(extensions, data)
        url = @rootUrl + extensions
        uri = URI.parse(url)
        req = Net::HTTP::Post.new(uri)
        req.body = encode(data)
        req['Authorization'] = @apiKey
        req['Content-Type'] = "application/json"

        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') {|http|
            http.request(req)
        }

        return res

    end
    
    protected :post

    # #
    # Makes a PUT request to the API
    #
    # @param [String] extensions - The extentions to be added to the root url
    # @param [Hash] data - The data to be supplied to the PUT request
    #
    # @return [Hash] The response from the API request
    #
    def put(extensions, data)
        url = @rootUrl + extensions
        uri = URI.parse(url)
        req = Net::HTTP::Put.new(uri)
        req.body = encode(data)
        req['Authorization'] = @apiKey
        req['Content-Type'] = "application/json"

        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') {|http|
            http.request(req)
        }

        return res
    end

    protected :put

    # #
    # Makes a PATCH request to the API
    #
    # @param [String] extensions - The extentions to be added to the root url
    # @param [Hash] data - The data to be supplied to the PATCH request
    #
    # @return [Hash] The response from the API request
    #
    def patch(extensions, data)
        url = @rootUrl + extensions
        uri = URI.parse(url)
        req = Net::HTTP::Patch.new(uri)
        req.body = encode(data)
        req['Authorization'] = @apiKey
        req['Content-Type'] = "application/json"

        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') {|http|
            http.request(req)
        }

        return res
    end

    protected :patch

    # #
    # Makes a DELETE request to the API
    #
    # @param [String] extensions - The extentions to be added to the root url
    #
    # @return [Hash] The response from the API request
    #
    def delete(extensions)
        url = @rootUrl + extensions
        uri = URI.parse(url)
        req = Net::HTTP::Delete.new(uri)
        req['Authorization'] = @apiKey

        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') {|http|
            http.request(req)
        }

        return res
    end

    protected :delete

end