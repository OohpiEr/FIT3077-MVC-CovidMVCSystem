class BookingsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "bookings_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
