import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  
  connect() {
    this.sessionUUID = this.element.dataset.session
    console.log("connect");
    window.debbie = () => {
      console.log("{\\__/}\n( •.•)\n/ >< \\");
      console.log("You found me !");
      this.seekRabbit(this.element.dataset.key, this.element.dataset.uuid);
    };
  }

  seekRabbit(key, uuid) {
    const requestData = {
      rabbit_key: key,
      rabbit_uuid: uuid,
      session_uuid: this.sessionUUID
    };
  
    fetch("/seek_rabbit", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(requestData)
    })
  }
  
}
