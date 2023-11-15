import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.requestNextInteraction();
  }

 
  requestNextInteraction() {
    const requestData = {
      rabbit: this.element.dataset.rabbit,
      session_uuid: this.element.dataset.sessionUuid,
    };

    fetch("/next_interaction", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(requestData),
    });
  }

  answerQuestion(answer) {
    const requestData = {
      anwser: answer,
      rabbit: this.element.dataset.rabbit,
      session_uuid: this.element.dataset.sessionUuid,
    };

    fetch("/answer_question", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(requestData),
    });
  }
}
