import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.keySequence = [];
    window.addEventListener("keyup", this.pushKeySequence.bind(this));
  }

  pushKeySequence(event) {
    this.keySequence.push(event.key);
    if (this.keySequence.length > 7) {
      this.keySequence.shift();
    }
    if (this.keySequence.join("") === "STEEVIE") {
      this.seekRabbit(this.element);
    }
  }

  seekRabbit(element) {
    if (!element.dataset.key && !element.dataset.uuid) return;
    const requestData = {
      rabbit_key: element.dataset.key,
      rabbit_uuid: element.dataset.uuid,
    };

    return fetch("/seek_rabbit", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(requestData),
    });
  }
}
