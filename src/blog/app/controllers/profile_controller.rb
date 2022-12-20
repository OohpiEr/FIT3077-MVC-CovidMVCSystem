require_relative '../../../handler/booking_handler'
require_relative '../../../handler/testing_site_handler'
require_relative '../../../registration/booking'
require_relative '../../../registration/booking_status'
require_relative '../../../user/package'
require_relative 'booking_updater'

#
# controller for profile 
#
class ProfileController < ApplicationController

    include BookingUpdater
    # before_action :setBooking, only: %i[show modify]
    before_action :validateUserResident, only: %i[index]
    before_action :setBooking, only: %i[show]

    
    @@bookingHandler = BookingHandler.getInstance

    def show; end

    #
    # Controller for profile/index
    # Separates active and lapsed Bookings
    #
    def index
        allBookings = @@bookingHandler.getBookings
        # @bookings = allBookings
        @activeBookings = []
        @lapsedBookings = []
        @homeBookings = []
        allBookings.each do |booking|
            if booking.customer[:id] == @user.id
                if booking.testingSiteData 
                    if booking.startTime > Time.now
                        @activeBookings.append(booking)
                    else
                        @lapsedBookings.append(booking)
                    end
                else
                    @homeBookings.append(booking)
                end
            end
        end
    end

    #
    # Controller for canceling bookings
    #
    def cancel
        bookingId = params[:bookingId]
        booking = BookingHandler.getInstance.getBooking(bookingId)
        response = BookingHandler.getInstance.cancelBooking(bookingId)
        flash[:notice] = response[:details]

        if response[:success]
            bookingUpdated(booking.id, "Booking Cancelled", booking.getTestingSiteId)
        end

        redirect_back fallback_location: profile_index_path
    end
    
    #
    # Controller for profile/modify
    # Called on rendering profile/modify page
    #
    def modify; end

    #
    # Controller for modify form submission
    # Called on submission of the modify form
    # Validate inputs and modifies booking
    #
    def submit
        testingSiteHandler = TestingSiteHandler.getInstance
        booking = @@bookingHandler.getBooking(params[:bookingId])
        valid = true
        startTime = ""
        data = {}

        if (params[:testingsite_id] == "" or params[:testingsite_id] == nil) and (params[:startTime] == "" or params[:startTime] == nil) 
            valid = false
            flash[:notice] = "Please enter data to be modified!"
        else 
            if params[:testingsite_id] != ""
                testingSite = testingSiteHandler.getTestingSite(params[:testingsite_id])
                
                if testingSite == nil
                    valid = false
                    flash[:notice] = "Invalid Testing Site ID!"
                else
                    data[:testingSiteId] = testingSite.id
                end
            end
        end

        if params[:startTime] != "" and params[:startTime] != nil
            if Time.parse(params[:startTime]) < Time.now
                valid = false
                flash[:notice] = "Invalid Start Time!"
            else
                data[:startTime] = params[:startTime]
            end
        end

        if !valid
            redirect_back fallback_location: profile_modify_path
        else
            @@bookingHandler.modifyBooking(booking.id, data)
            flash[:notice] = "Booking successfully modified"
            affectedTestingSites = [booking.testingSiteData[:id]]
            updateMessage = ""
            if data[:startTime]
              updateMessage << "Booking Start Time Changed\n"
            end
            if data[:testingSiteId]
              updateMessage << "Booking Testing Site Changed\n"
              affectedTestingSites << data[:testingSiteId]
            end
            
            bookingUpdated(booking.id, updateMessage, affectedTestingSites)

            redirect_to profile_show_path(booking.id)
        end
    end

    #
    # Controller for undo
    # Called when undo button is clicked
    # Checks if undoing is possible
    #
    def undo 
        begin
            # get data
            booking = @@bookingHandler.getBooking(params[:format])
            oldTestingSiteId = booking.testingSiteData[:id]
            oldStartTime = booking.startTime

            # try to undo
            if not @@bookingHandler.undoBooking(params[:format])
                flash[:notice] = "Cannot undo more than 3 times!"
            else
                # undo successfull
                updateMessage = ""
                booking = @@bookingHandler.getBooking(params[:format])
                affectedTestingSites = [oldTestingSiteId]

                # output messages
                if booking.testingSiteData[:id] != oldTestingSiteId
                    affectedTestingSites << booking.testingSiteData[:id]
                    updateMessage << "Booking Testing Site Changed\n"
                end
                if booking.startTime != oldStartTime
                    updateMessage << "Booking Start Time Changed\n"
                end

                bookingUpdated(booking.id, updateMessage, affectedTestingSites)
            end
        rescue LapsedStartTimeException
            flash[:notice] = "Cannot undo: Start time has lapsed!"
        end
        redirect_to profile_show_path(params[:format])
    end

    #
    # Sets @booking to Booking object with current booking id
    #
    def setBooking
        @booking = @@bookingHandler.getBooking(params[:format])
    end

    #
    # Checks whether current user is a Resident
    # Redirects back if not.
    #
    def validateUserResident
        redirect_back fallback_location: home_index_path if not @isCustomer
    end
end
