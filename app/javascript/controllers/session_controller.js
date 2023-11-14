import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    window.addEventListener("focus", ()=> this.handleTabFocus());
    window.addEventListener("blur", ()=>this.handleTabBlur());
    this.updateSessionStatus("connected")
  }

  handleTabFocus() {
    this.updateSessionStatus("connected")
  }

  handleTabBlur() {
    this.updateSessionStatus("disconnected")
  }

  updateSessionStatus(newStatus) {

    const requestData = {
        session_uuid: this.element.dataset.sessionUuid,
        new_status: newStatus,
      };

    fetch("/update_session_status", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(requestData),
      });
  }
}
