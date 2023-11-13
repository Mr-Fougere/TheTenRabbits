import { Controller } from "@hotwired/stimulus";
import { seekRabbit } from "./application";

export default class extends Controller {
  static targets = ["bush", "field"];

  connect() {
    this.selectedBush = null;
    this.fieldTarget.addEventListener(
      "mousemove",
      this.moveSelectedBush.bind(this)
    );
    this.fieldTarget.addEventListener("mouseup", () => {
      this.selectedBush = null;
    });
  }

  toggleBush(event) {
    if (this.selectedBush == event.currentTarget) {
      this.selectedBush = null;
    } else if (!this.selectedBush){
      this.selectedBush = event.currentTarget;
    }

    this.fieldTarget.insertBefore(
      this.selectedBush,
      this.fieldTarget.firstChild
    );
    this.moveSelectedBush(event)
  }

  toggleBehindBush(event) {
    seekRabbit(event.currentTarget);
  }

  moveSelectedBush(event) {
    if (!this.selectedBush) return;

    const elementWidth = this.selectedBush.offsetWidth;
    const elementHeight = this.selectedBush.offsetHeight;
    const mouseX = event.clientX;
    const mouseY = event.clientY;

    const left = mouseX - elementWidth / 2;
    const top = mouseY - elementHeight;

    this.selectedBush.style.left = left + "px";
    this.selectedBush.style.top = top + "px";
  }
}
