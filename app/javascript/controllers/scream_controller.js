import { Controller } from "@hotwired/stimulus";
import { seekRabbit } from "./application";

export default class extends Controller {
  connect() {
    this.keySequence = [];
    console.log("Scream controller connected");
    window.addEventListener("keyup", this.pushKeySequence.bind(this));
  }

  pushKeySequence(event) {
    this.keySequence.push(event.key);
    if (this.keySequence.length > 7) {
      this.keySequence.shift();
    }
    console.log(this.keySequence.join(""));
    if (this.keySequence.join("") === "STEEVIE") {
      const uuid = this.element.dataset.uuid;
      const key = this.element.dataset.key;
      seekRabbit(key, uuid);
    }
  }
}
