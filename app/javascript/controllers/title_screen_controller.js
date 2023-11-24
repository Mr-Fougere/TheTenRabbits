import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "titleContainer",
    "titleButton",
    "titleScreen",
    "titleWarning",
  ];

  connect() {
    const observer = new MutationObserver((e) => {

      const connection_state = e[0].target.attributes["connected"] !== undefined;
      this.changeState(connection_state);

    });

    const element = document.querySelector("turbo-cable-stream-source");
    observer.observe(element, { attributeFilter: ["connected"] });
    this.changeState(element.attributes["connected"] !== undefined)
  }

  launchIntroduction() {
    this.animationTitleScreen();
  }

  continueSession() {
    this.animationTitleScreen();
  }

  changeState(connection_state) {
    if (connection_state) {
      this.enableButton();
    } else {
      this.disableButton();
    }
  }

  animationTitleScreen() {
    this.titleContainerTarget.classList.add("screen-out-up");
    this.titleButtonTarget.classList.add("screen-out-down");
    this.titleWarningTarget.classList.add("screen-out-down");
    this.titleScreenTarget.classList.add("fade-out");

    setTimeout(() => {
      this.titleScreenTarget.remove();
    }, 2000);
  }

  enableButton() {
    this.titleButtonTarget.disabled = false;
  }

  disableButton() {
    this.titleButtonTarget.disabled = true;
  }
}
