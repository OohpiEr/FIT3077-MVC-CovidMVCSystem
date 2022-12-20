require_relative 'booking'


#
# Caretaker class for booking memento pattern
#
class BookingCaretaker

    #
    # Constructor
    #
    # @param [Booking] booking booking object (originator)
    #
    def initialize(booking)
        @booking = booking # orginator
        @undoCount = initUndoCount()
        @history = initHistory()
    end

    private
    #
    # Initializes history of caretaker from additionalInfo in Booking object
    #
    # @return [Array] array of mementos in history
    #
    def initHistory()
      history = []

      if @booking.additionalInfo[:mementos] != nil
        @booking.additionalInfo[:mementos].each do |memento|
          history << @booking.getMemento(memento)
        end
      end

      return history
    end
    
    #
    # Initializes undoCount
    #
    # @return [Integer] undoCount
    #
    def initUndoCount()
        undoCount = 0

        if @booking.additionalInfo[:undoCount] != nil
            undoCount = @booking.additionalInfo[:undoCount]
        end

        return undoCount
    end

    #
    # Checks if startTime has lapsed 
    #
    # @return [Booelan] whether startTime has lapsed 
    #
    def checkStartTime
        if @history[-1].state[:startTime] < Time.now then return false else return true end
    end

    public
    #
    # Calls booking.save to save currnt state of booking instance and updates history along with undoCount
    #
    def save
        @history << @booking.save

        if @undoCount > 0
            @undoCount -= 1
        elsif @undoCount < 0
            @undoCount == 0
        end
        @booking.additionalInfo[:undoCount] = @undoCount
    end
    
    #
    # Calls booking.restore to restore booking state to the latest memento stored in history.
    # Updates history and undoCount.
    #
    def undo
        raise LapsedStartTimeException.new if not checkStartTime() 
        return false if @history.empty? 

        
        # pop from history
        memento = @history.pop
        @booking.additionalInfo[:mementos].pop
        
        # update undo count
        @undoCount += 1
        @booking.additionalInfo[:undoCount] = @undoCount
        begin
            @booking.restore(memento)
        rescue StandardError
            undo
        end
    end

end

#
# Exception Class for Lapsed start time
#
class LapsedStartTimeException < StandardError
    #
    # Constructor
    #
    # @param [string] msg message
    # @param [string] exception_type exception type
    #
    def initialize(msg="Start time has lapsed", exception_type="start time exception")
      @exception_type = exception_type
      super(msg)
    end
end