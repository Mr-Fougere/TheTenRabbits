import { Controller } from "@hotwired/stimulus";
import { seekRabbit } from "./seek_controller";

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
      seekRabbit(this.element);
    }
  }
}
