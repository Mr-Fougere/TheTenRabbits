import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["message"];

  connect() {
    this.maxMessageLenght = 16;
    this.message = "";
  }

  talkToLarry() {
    const requestData = {
      session_uuid: this.element.dataset.sessionUuid,
      message: this.message,
    };

    fetch("/talk_larry", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(requestData),
    });
  }

  addPawToMessage(event) {
    if (this.message.length >= this.maxMessageLenght) return;
    const messagePaw = event.currentTarget.cloneNode(true);
    const intPaw = messagePaw.dataset.paw;
    this.message += intPaw;
    this.messageTarget.appendChild(messagePaw);
  }

  sendMessage() {
    this.talkToLarry();
    this.message = "";
    while (this.messageTarget.firstChild) {
        this.messageTarget.removeChild(this.messageTarget.firstChild);
    }
  }
}
