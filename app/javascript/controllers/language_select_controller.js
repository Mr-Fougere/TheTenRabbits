import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.selectedLanguage = this.element.querySelector(".selected");
  }

  switchLanguage(event) {
    const newLanguage = event.currentTarget;
    if (newLanguage == this.selectedLanguage) return;

    this.selectedLanguage.classList.remove("selected");
    newLanguage.classList.add("selected");
    this.selectedLanguage = newLanguage;
    this.requestLanguage();
  }

  requestLanguage() {
    const requestData = {
        language: this.selectedLanguage.dataset.language,
        session_uuid: this.element.dataset.sessionUuid
    };

    fetch("/switch_language", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(requestData),
    });
  }
}
