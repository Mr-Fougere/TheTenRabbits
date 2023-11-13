import { Controller } from "@hotwired/stimulus";
import { seekRabbit } from "./application";

export default class extends Controller {
  static targets = ["mobile"];

  connect() {
    this.mobileTargets.forEach((target) => {
        target.addEventListener("click", () => {
            seekRabbit(target);
        })
    })
  }
}
