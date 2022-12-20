#
# Booking memento interface
#
class BookingMemento 
 
    #
    # Function to return state of memento
    #
    # @raise NotImplementedError
    #
    def state
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end
end