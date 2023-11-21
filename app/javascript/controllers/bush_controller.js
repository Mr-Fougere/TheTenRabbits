import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["field"];

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
    } else if (!this.selectedBush) {
      this.selectedBush = event.currentTarget;
    }

    this.fieldTarget.insertBefore(
      this.selectedBush,
      this.fieldTarget.firstChild
    );
    this.moveSelectedBush(event);
  }

  toggleBehindBush(event) {
    this.seekRabbit(event.currentTarget);
  }

  moveSelectedBush(event) {
    if (!this.selectedBush) return;

    const elementWidth = this.selectedBush.offsetWidth;
    const elementHeight = this.selectedBush.offsetHeight;

    const fieldLeft = this.fieldTarget.offsetLeft;
    const fieldTop = this.fieldTarget.offsetTop;

    const mouseX = event.clientX;
    const mouseY = event.clientY;

    const left = mouseX - elementWidth / 2 - fieldLeft;
    const top = mouseY - elementHeight / 2 - fieldTop;
    this.selectedBush.style.left = left + "px";
    this.selectedBush.style.top = top + "px";
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
