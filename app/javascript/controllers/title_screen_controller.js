import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["titleContainer", "titleButton","titleScreen"];

  connect() {}

  launchIntroduction() {
    this.animationTitleScreen()
  }

  continueSession() {
    this.animationTitleScreen()
  }

  animationTitleScreen() {
    this.titleContainerTarget.classList.add("screen-out-up");
    this.titleButtonTarget.classList.add("screen-out-down");
    this.titleScreenTarget.classList.add("fade-out");

    setTimeout(() => {
      this.titleScreenTarget.remove()
    }, 3000);
  }
}
