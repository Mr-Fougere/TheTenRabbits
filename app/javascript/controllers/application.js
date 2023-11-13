import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

window.ondragstart = function() { return false; } 

export function seekRabbit(key, uuid, sessionUUID) {
    const requestData = {
      rabbit_key: key,
      rabbit_uuid: uuid,
      session_uuid: sessionUUID,
    };
  
    return fetch("/seek_rabbit", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(requestData),
    });
  }
  