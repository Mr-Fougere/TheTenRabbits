import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.voted = this.element.dataset.voted === "true";
  }

  voteRabbit(event) {
    if (this.voted === true) return;

    const requestData = {
      session_uuid: this.element.dataset.sessionUuid,
      rabbit_name: event.currentTarget.dataset.rabbitName,
    };

    fetch("/vote_rabbit", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(requestData),
    });

    this.voted = true;
    event.currentTarget.classList.add("selected");
  }
}
