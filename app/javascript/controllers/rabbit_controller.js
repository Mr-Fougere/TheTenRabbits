import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.requestCurrentSpeech();
  }

 
  requestCurrentSpeech() {
    const requestData = {
      rabbit_uuid: this.element.dataset.rabbitUuid,
      session_uuid: this.element.dataset.sessionUuid,
    };

    fetch("/current_speech", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(requestData),
    });
  }

  answerSpeech(event) {
    const requestData = {
      answer: event.currentTarget.dataset.answer,
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
}
