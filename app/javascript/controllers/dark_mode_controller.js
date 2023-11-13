import { Controller } from "@hotwired/stimulus";
import { seekRabbit } from "./application";

export default class extends Controller {
  connect() {
    this.switchMode(window.matchMedia('(prefers-color-scheme: dark)').matches ? "dark" : "light");
    window
      .matchMedia("(prefers-color-scheme: dark)")
      .addEventListener("change", (event) => {
        this.switchMode(event.matches ? "dark" : "light");
      });
  }

  switchMode(new_mode) {
    const requestData = {
      uuid: this.element.dataset.sessionUuid,
      mode: new_mode,
    };

    fetch("/switch_mode", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(requestData),
    });
  }

    
  toggle(event){
    seekRabbit(event.currentTarget);
  }

}
