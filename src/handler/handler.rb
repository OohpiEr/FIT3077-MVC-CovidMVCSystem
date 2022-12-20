# #
# An abstract base class for Handler classes

class Handler

    #
    # Constructor. Enforces the abstract class behavior
    #
    def initialize
        raise "This is an abstract class. It shouldn't be instantiated"
    end


    #
    # Symbolises all the names/keys inside a hash
    #
    # @param [Hash] hash - The hash to symbolise
    #
    # @return [Hash] - The hash with symbolised names/keys
    #
    def symbolizeNames(hash)
        return JSON.parse(JSON.generate(hash), symbolize_names: true)
    end

    protected :symbolizeNames

end