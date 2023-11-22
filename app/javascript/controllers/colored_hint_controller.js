// Modifiez votre fichier Stimulus
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  
  connect() {
  
  }

  switchColoredHint() {
    const requestData = {
        session_uuid: this.element.dataset.sessionUuid
    };

    fetch("/switch_colored_hint", {
      method: "POST",
      body: JSON.stringify(requestData),
    })
  }
}
