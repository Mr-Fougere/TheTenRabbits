import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["message"];

  connect() {
    this.maxMessageLenght = 16;
    this.message = "";
  }

  answerSpeech() {
    const requestData = {
      answer: this.message,
      rabbit_uuid: this.element.dataset.rabbitUuid,
      session_uuid: this.element.dataset.sessionUuid,
    };

    fetch("/answer_speech", {
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
    this.answerSpeech();
    this.message = "";
    while (this.messageTarget.firstChild) {
        this.messageTarget.removeChild(this.messageTarget.firstChild);
    }
  }
}
