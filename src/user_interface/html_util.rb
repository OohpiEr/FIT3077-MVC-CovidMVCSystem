class HTMLUtil

    #
    # Returns a hash's information in HTML format
    #
    # @param [Hash] hash - The hash to be formatted
    #
    # @return [String] - The hash's information in HTML format
    #
    def self.getHTMLFromHash(hash)
        html = ""
        for key, value in hash
            html += "#{key.capitalize}: #{value}<br>"
        end
        return html
    end

end