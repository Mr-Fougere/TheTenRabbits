import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["rabbitFound"];

  connect() {
    document.onchange = () => {
      console.log("ici");

      const sparky = this.element.querySelector(".sparky");
      this.requestCurrentSpeech(sparky);
    };
  }

  requestCurrentSpeech(rabbit) {
    const requestData = {
      rabbit_uuid: rabbit.dataset.rabbitUuid,
      session_uuid: rabbit.dataset.sessionUuid,
    };

    fetch("/current_speech", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(requestData),
    });
  }
}
