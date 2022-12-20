require_relative 'booking_memento'


#
# Concrete Booking Memento Class
#
class BookingConcreteMemento < BookingMemento

    #
    # Conteructor
    #
    # @param [hash] state state of the booking object
    #
    def initialize(state)
        @state = state
    end

    # Getter/reader for state
    attr_reader :state
    
end