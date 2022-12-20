import consumer from "channels/consumer"

if (gon.isReceptionist || gon.isHealthcareWorker){

  consumer.subscriptions.create("BookingsChannel", {
    connected() {
      console.log("Connected")
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      if (data.testingSiteIds.includes(gon.userTestingSiteId)){
        alert(data.message)
      }
    }
  });
  
}
